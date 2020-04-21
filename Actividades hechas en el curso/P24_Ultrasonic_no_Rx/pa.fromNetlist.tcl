
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name P24_Ultrasonic -dir "C:/Users/Surface Pro/Documents/TEC/SisDigAva/RICK/P24_Ultrasonic_no_Rx/planAhead_run_1" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Surface Pro/Documents/TEC/SisDigAva/RICK/P24_Ultrasonic_no_Rx/Ultrasonic.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Surface Pro/Documents/TEC/SisDigAva/RICK/P24_Ultrasonic_no_Rx} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "Ultrasonic.ucf" [current_fileset -constrset]
add_files [list {Ultrasonic.ucf}] -fileset [get_property constrset [current_run]]
link_design
