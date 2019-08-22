module Opps
  Add = '+'
  Sub = '-'
  Mult = '*'
  Div = '/'
  All = Opps.constants(false).map { |c| Opps.const_get c }
end

def main
  target = ARGV[0].to_i
  source_values = ARGV[1..-1].map(&:to_i)

  puts "Source Values: #{source_values.join(' ')}"
  puts "Target: #{target}"
  puts "calculating..."

  best = find_best(
    target: target,
    steps: [],
    remaining_values: source_values,
  )

  puts ''

  puts best.join(' ')
  puts " = #{calculate_result(steps: best)}"
end

def find_best(target:, steps:, remaining_values:)
  if calculate_result(steps: steps) == target || remaining_values.size == 0
    return steps
  end

  possible_step_sets = remaining_values.map.with_index do |value, index|
    if steps.size == 0
      new_steps = steps + [value]
      new_remaining_values = remaining_values.dup
      new_remaining_values.delete_at(index)

      [
        find_best(
          target: target,
          steps: new_steps,
          remaining_values: new_remaining_values,
        )
      ]
    else
      Opps::All.map do |opp|
        new_steps = steps + [opp, value]
        new_remaining_values = remaining_values.dup
        new_remaining_values.delete_at(index)

        find_best(
          target: target,
          steps: new_steps,
          remaining_values: new_remaining_values,
        )
      end
    end
  end.flatten(1)

  possible_step_sets.sort_by do |steps|
    [
      (target - calculate_result(steps: steps)).abs,
      steps.size,
    ]
  end.first
end

def calculate_result(steps:)
  steps_copy = steps.dup
  result = steps_copy.shift
  while steps_copy.size > 0
    opp = steps_copy.shift
    value = steps_copy.shift

    if opp == Opps::Add
      result = result + value
    elsif opp == Opps::Sub
      result = result - value
    elsif opp == Opps::Mult
      result = result * value
    elsif opp = Opps::Div
      result = result / value.to_f
    else
      fail(opp)
    end
  end
  return result
end

main
