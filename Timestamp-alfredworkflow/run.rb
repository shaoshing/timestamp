command, task_name = ARGV[0].split("/")
is_describe_command = !!ARGV[1]

return if is_describe_command ? command != "describe task" : command == "describe task"

apple_script =  %{tell application "Timestamp" to #{command}}
apple_script += %{ with name "#{task_name}"} if task_name
result=`osascript -e '#{apple_script}'`

if is_describe_command
  puts result
else
  puts %{#{command}#{task_name && " with name [#{task_name}]"}.}
end
