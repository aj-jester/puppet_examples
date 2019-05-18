require 'spec_helper'

describe 'ansible', :type => :class do

    it { is_expected.to compile.with_all_deps }

end
