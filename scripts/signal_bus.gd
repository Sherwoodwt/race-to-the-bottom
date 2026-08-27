extends Node

@warning_ignore_start("unused_signal")

signal alert(text: String)

signal focus_changed(role: Role)
signal highlight(target: PortraitButton)
signal team_tasks(employee: Employee)
signal team_org(employee: Employee)
signal fired(employee: Employee)
signal refresh_tree

signal task_finished(task: Task)
signal task_started(task: Task)
signal tasks_updated(count: int)

signal productivity_changed
signal day_end(new_day: int)
signal new_quarter(new_quarter: int)
signal task_timeout(time_left: float)
signal call_alert
signal lose(reason: String)
signal pause
signal toggle_pause
signal quit_to_menu
signal open_tutorial
signal open_creator

@warning_ignore_restore("unused_signal")
