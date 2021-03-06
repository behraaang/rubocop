# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::EnvironmentComparison do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense and corrects comparing Rails.env to a string' do
    expect_offense(<<~RUBY)
      Rails.env == 'production'
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Favor `Rails.env.production?` over `Rails.env == 'production'`.
    RUBY

    expect_correction(<<~RUBY)
      Rails.env.production?
    RUBY
  end

  it 'registers an offense and corrects comparing Rails.env to a symbol' do
    expect_offense(<<~RUBY)
      Rails.env == :production
      ^^^^^^^^^^^^^^^^^^^^^^^^ Do not compare `Rails.env` with a symbol, it will always evaluate to `false`.
    RUBY

    expect_correction(<<~RUBY)
      Rails.env.production?
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      Rails.env.production?
      Rails.env.test?
    RUBY
  end
end
