require 'spec_helper'
describe 'kokos' do

  context 'with defaults for all parameters' do
    it { should contain_class('kokos') }
  end
end
