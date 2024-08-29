# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcpg236-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.cache/wt} [current_project]
set_property parent.project_path {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem {{C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/mem_init.mem}}
read_verilog -library xil_defaultlib {
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/FIFO_Wrapper.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/Read_logic.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/Write_logic.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/imports/new/bcd_to_hex.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/display_fifo.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/ram.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/synchronizer_unit.v}
  {C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/sources_1/new/Top_Module.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/constrs_1/new/fifo_constraint.xdc}}
set_property used_in_implementation false [get_files {{C:/Reality/Verilog Workspace/Sync_FIFO/Sync_FIFO.srcs/constrs_1/new/fifo_constraint.xdc}}]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Top_Module -part xc7a35tcpg236-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Top_Module.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Top_Module_utilization_synth.rpt -pb Top_Module_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
