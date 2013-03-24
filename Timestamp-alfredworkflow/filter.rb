command_filter = /#{ARGV[0]}/i
task_name = ARGV[0]
description_of_no_task="You have no task working on currently"
current_task_descrition=`osascript -e 'tell application "Timestamp" to describe task'`
noTask= current_task_descrition.include?(description_of_no_task)

commands = []
if noTask
  commands << if task_name.empty?
    {:arg => "start task", :title => "Start working", :subtitle => "with default task name."}
  else
    {:arg => "start task/#{task_name}", :title => "Start working on [#{task_name}]", :subtitle => ""}
  end
else
  [
    {:arg => "finish task", :title => "Stop working", :subtitle => "stop and save working time."},
    {:arg => "cancel task", :title => "Cancel", :subtitle => "stop and discard current working time."},
    {:arg => "describe task", :title => "Describe...", :subtitle => "How long have I been working on the task?"}
  ].each do |command|
    next unless command[:title] =~ command_filter
    commands << command
  end
end

items = ""
for command in commands
  items << <<-XML
  <item uid="" arg="#{command[:arg]}">
    <title>#{command[:title]}</title>
    <subtitle>#{command[:subtitle]}</subtitle>
    <icon type="">./icon.png</icon>
  </item>
  XML
end

puts <<-XML
<items>
  #{items}
</items>
XML
