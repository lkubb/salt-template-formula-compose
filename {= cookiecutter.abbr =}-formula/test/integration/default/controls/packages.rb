# frozen_string_literal: true

control '{= cookiecutter.abbr_pysafe =}.package.install' do
  title 'The required package should be installed'

  package_name = '{= cookiecutter.pkg =}'

  describe package(package_name) do
    it { should be_installed }
  end
end
