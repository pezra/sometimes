require "sometimes/version"

# -*- encoding : utf-8 -*-
# OH SO FUN HELPERS!

# RANDOMLY EXECUTES A BLOCK X percent OF THE TIME
#
# TEST WITH
#
# i = 0
# 100000.times do
#   75.percent_of_the_time do
#     i += 1
#   end
# end
# i
#
#
# 40.percent_of_the_time do
class Fixnum
  def percent_of_the_time(&block)
    raise(ArgumentError, 'Fixnum should be between 1 and 100 to be used with the times method') unless self > 0 && self <= 100
    Sometimes.new(probability: self.fdiv(100)).maybe(&block)
  end
end

# (3..6).times do
class Range
  def times(&block)
    Random.rand(self).times(&block)
  end
end

# half_the_time do
# sometimes do
class Object
  def half_the_time(&block)
    50.percent_of_the_time {yield}
  end
  alias :sometimes :half_the_time

  def rarely(&block)
    5.percent_of_the_time {yield}
  end

  def mostly(&block)
    95.percent_of_the_time {yield}
  end

  def never(&block)
  end

  def always(&block)
    yield
  end
end

# `Sometimes` objects provide work dodging behavior. The block passed to
# `#maybe` will be executed with the specified probability.
#
# If initialized with the `start_strong: true` then object will always execute
# the block the first time. After that it will revert to is normal work dodging
# behavior.
class Sometimes

  protected def initialize(probability: , start_strong: false)
    @next_run_required = start_strong
    @probability = probability
  end

  def maybe(&block)
    raise "Sometimes needs a job to skip out on." unless block_given?
    yield if next_run_required? || Kernel.rand() < probability
    @next_run_required = false
  end

  protected

  attr_reader :probability

  def next_run_required?
    @next_run_required
  end
end
