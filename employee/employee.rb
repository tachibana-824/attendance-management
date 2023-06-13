require 'date'

class TimeTrackingTool
  TASKS_FILE = 'tasks.txt'

  def initialize
    @tasks = load_tasks
  end

  def start_task(task_name)
    @tasks[task_name] = {start_time: Time.now, end_time: nil}
    save_tasks
    puts "Started task: #{task_name}"
  end

  def finish_task(task_name)
    if @tasks.key?(task_name)
      @tasks[task_name][:end_time] = Time.now
      save_tasks
      puts "Finished task: #{task_name}"
    else
      puts "Task '#{task_name}' not found"
    end
  end

  def show_today_tasks
    today = Date.today
    puts "Today's tasks:"
    total_work_time = 0
    @tasks.each do |task_name, task|
      if task[:start_time].to_date == today
        work_time = calculate_work_time(task)
        total_work_time += work_time
        puts "#{task_name}: #{task[:start_time]} - #{task[:end_time]} (Work Time: #{work_time})"
      end
    end
    puts "Total work time today: #{total_work_time}"
  end

  def show_week_tasks
    puts "Recent 7 days' tasks:"
    end_date = Date.today
    start_date = end_date - 6
    (start_date..end_date).each do |date|
      puts "#{date}:"
      total_work_time = 0
      @tasks.each do |task_name, task|
        if task[:start_time].to_date == date
          work_time = calculate_work_time(task)
          total_work_time += work_time
          puts "#{task_name}: #{task[:start_time]} - #{task[:end_time]} (Work Time: #{work_time})"
        end
      end
      puts "Total work time: #{total_work_time}"
    end
  end

  private

  def load_tasks
    if File.exist?(TASKS_FILE)
      File.open(TASKS_FILE, 'r') { |file| Marshal.load(file) }
    else
      {}
    end
  end

  def save_tasks
    File.open(TASKS_FILE, 'w') { |file| Marshal.dump(@tasks, file) }
  end

  def calculate_work_time(task)
    if task[:end_time].nil?
      Time.now - task[:start_time]
    else
      task[:end_time] - task[:start_time]
    end
  end
end

# コマンドライン引数の解析
option = ARGV[0]
task_name = ARGV[1]

# TimeTrackingToolのインスタンスを作成
time_tracking_tool = TimeTrackingTool.new

# オプションに基づいて処理を実行
case option
when '-s', '--start'
  time_tracking_tool.start_task(task_name)
when '-f', '--finish'
  time_tracking_tool.finish_task(task_name)
when '-st', '--show-today'
  time_tracking_tool.show_today_tasks
when '-sw', '--show-week'
  time_tracking_tool.show_week_tasks
else
  puts 'Invalid option'
end
