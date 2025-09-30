# Test file for iron.nvim REPL

# First, let's check if sum is working correctly
print("Testing built-in sum function:")
print(type(sum))

# If sum was accidentally overwritten, reset it
# You can check this by running: type(sum)
# It should show: <class 'builtin_function_or_method'>

# Create a list
numbers = [1, 2, 3, 4, 5]
print(f"Numbers list: {numbers}")

# Calculate sum
result = sum(numbers)
print(f"Sum of numbers: {result}")

# If you get an error, you might have defined sum as something else
# To fix it, restart your Python REPL with <space>rr

# Alternative test without sum:
total = 0
for num in numbers:
    total += num
print(f"Manual sum: {total}")