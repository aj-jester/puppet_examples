Puppet::Functions.create_function(:consul_lookup_key) do

  require 'net/http'
  require 'base64'
  require 'json'
  require 'uri'

  dispatch :consul_lookup_key do
    param 'String[1]', :key
    param 'Hash[String[1],Any]', :options
    param 'Puppet::LookupContext', :context
  end

  def consul_lookup_key key, options, context
    if context.cache_has_key(key)
      context.explain { "consul_lookup_key: Returning cached value for #{key}" }
      return context.cached_value key
    else
      return fresh_value key, options, context
    end
  end

  def fresh_value key, options, context

    begin
      uri = URI.parse(options['uri'] + "/" + key.gsub("::", "/"))
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = options['timeout']

      request = Net::HTTP::Get.new(uri.request_uri)
      request.initialize_http_header({'X-Consul-Token' => options['token']})

      context.explain { "consul_lookup_key: Calling #{uri}" }
      response = http.request request

    rescue Timeout::Error
      raise Puppet::DataBinding::LookupError, "consul_lookup_key backend timeout (#{options['timeout']})."

    rescue Errno::EINVAL, Errno::ECONNRESET, EOFError,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise Puppet::DataBinding::LookupError, "consul_lookup_key net_http: #{e.message}."
    end

    response_code = response.code.to_i

    if response_code == 200

      begin
        values = JSON.parse(response.body)

        if values.size == 1
          decoded_value = context.interpolate Base64.decode64 values.first['Value']

          context.cache(key, decoded_value)
          context.explain { "consul_lookup_key: Returning fresh value for #{key}" }

          return decoded_value

        else
          raise Puppet::DataBinding::LookupError, "consul_lookup_key: #{values.size} values found, expecting 1."
        end

      rescue JSON::ParserError
        raise Puppet::DataBinding::LookupError, 'consul_lookup_key: Unable to parse JSON.'
      end

    elsif response_code == 404
      context.explain { "consul_lookup_key 404 key not found: #{key}. Check if key and valid ACL rule exist." }
      context.not_found

    elsif response_code == 403
      raise Puppet::DataBinding::LookupError, 'consul_lookup_key 403 forbidden: Check Token and ACL rules.'

    else
      raise Puppet::DataBinding::LookupError, "consul_lookup_key #{response.code}: #{response.body}"
    end

  end

end
