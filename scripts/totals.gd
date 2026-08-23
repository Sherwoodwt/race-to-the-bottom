extends Node

@onready var tasks: Label = $Panel/Tasks
@onready var money: TextureProgressBar = $Panel/Money
@onready var productivity: TextureProgressBar = $Panel/Productivity
@onready var q_time: TextureProgressBar = $Panel/Q_Time

# TODO: Hook into signals on metrics screen to display here
