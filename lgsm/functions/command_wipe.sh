#!/bin/bash
# LinuxGSM command_backup.sh function
# Author: Daniel Gibbs
# Contributor: UltimateByte
# Website: https://linuxgsm.com
# Description: Wipes server data, useful after updates for some games like Rust

commandname="WIPE"
commandaction="Wiping"
functionselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

# Provides an exit code upon error.
fn_wipe_exit_code(){
	((exitcode=$?))
	if [ ${exitcode} -ne 0 ]; then
		fn_script_log_fatal "${currentaction}"
		core_exit.sh
	else
		fn_print_ok_eol_nl
	fi
}

# Removes files to wipe server.
fn_wipe_server_files(){
	fn_print_start_nl "Wiping server"
	fn_script_log_info "Wiping server"
	# Wipe procedural map.
	if [ "$(find "${serveridentitydir}" -type f -name "proceduralmap.*.map")" ]; then
		echo -en "removing procedural map proceduralmap.*.map file(s)..."
		fn_sleep_time
		fn_script_log "Removing procedural map file(s): ${serveridentitydir}/proceduralmap.*.map"
		find "${serveridentitydir:?}" -type f -name "proceduralmap.*.map" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no procedural map file to remove"
		fn_sleep_time
		fn_script_log_pass "No procedural map file to remove"
	fi
	# Wipe procedural map save.
	if [ "$(find "${serveridentitydir}" -type f -name "proceduralmap.*.sav")" ]; then
		echo -en "removing map saves proceduralmap.*.sav file(s)..."
		fn_sleep_time
		fn_script_log "Removing procedural map save(s): ${serveridentitydir}/proceduralmap.*.sav"
		find "${serveridentitydir:?}" -type f -name "proceduralmap.*.sav" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no procedural map save to remove"
		fn_sleep_time
		fn_script_log_pass "No procedural map save to remove"
	fi
	# Wipe Barren map.
	if [ "$(find "${serveridentitydir}" -type f -name "barren*.map")" ]; then
		echo -en "removing barren map barren*.map file(s)..."
		fn_sleep_time
		fn_script_log "Removing map file(s): ${serveridentitydir}/barren*.map"
		find "${serveridentitydir:?}" -type f -name "barren*.map" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no barren map file to remove"
		fn_sleep_time
		fn_script_log_pass "No barren map file to remove"
	fi
	# Wipe barren map save.
	if [ "$(find "${serveridentitydir}" -type f -name "barren*.sav")" ]; then
		echo -en "removing barren map saves barren*.sav file(s)..."
		fn_sleep_time
		fn_script_log "Removing barren map save(s): ${serveridentitydir}/barren*.sav"
		find "${serveridentitydir:?}" -type f -name "barren*.sav" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no barren map save to remove"
		fn_sleep_time
		fn_script_log_pass "No barren map save to remove."
	fi
	# Wipe user dir, might be a legacy thing, maybe to be removed.
	if [ -d "${serveridentitydir}/user" ]; then
		currentaction="removing user directory: ${serveridentitydir}/user"
		echo -en "removing user directory..."
		fn_sleep_time
		fn_script_log "${currentaction}"
		rm -rf "${serveridentitydir:?}/user"
		fn_wipe_exit_code
		fn_sleep_time
		# We do not print additional information if there is nothing to remove since this might be obsolete.
	fi
	# Wipe storage dir, might be a legacy thing, maybe to be removed.
	if [ -d "${serveridentitydir}/storage" ]; then
		currentaction="removing storage directory: ${serveridentitydir}/storage"
		echo -en "removing storage directory..."
		fn_sleep_time
		fn_script_log "${currentaction}"
		rm -rf "${serveridentitydir:?}/storage"
		fn_wipe_exit_code
		fn_sleep_time
		# We do not print additional information if there is nothing to remove since this might be obsolete.
	fi
	# Wipe sv.files.
	if [ "$(find "${serveridentitydir}" -type f -name "sv.files.*.db")" ]; then
		echo -en "removing server misc srv.files*.db file(s)..."
		fn_sleep_time
		fn_script_log "Removing server misc files: ${serveridentitydir}/sv.files.*.db"
		find "${serveridentitydir:?}" -type f -name "sv.files.*.db" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
		# No further information if not found because it should I could not get this file showing up.
	fi
	# Wipe player death files.
	if [ "$(find "${serveridentitydir}" -type f -name "player.deaths.*.db")" ]; then
		echo -en "removing player deaths player.deaths.*.db file(s)..."
		fn_sleep_time
		fn_script_log "Removing player death files: ${serveridentitydir}/player.deaths.*.db"
		find "${serveridentitydir:?}" -type f -name "player.deaths.*.db" -delete | tee -a "${lgsmlog}"
		fn_wipe_exit_code
		fn_sleep_time
	else
		echo -e "no player death to remove"
		fn_sleep_time
		fn_script_log_pass "No player death to remove"
	fi
	# Wipe blueprints only if wipeall command was used.
	if [ "${wipeall}" == "1" ]; then
		if [ "$(find "${serveridentitydir}" -type f -name "player.blueprints.*.db")" ]; then
			echo -en "removing blueprints player.blueprints.*.db file(s)..."
			fn_sleep_time
			fn_script_log "Removing blueprint file(s): ${serveridentitydir}/player.blueprints.*.db"
			find "${serveridentitydir:?}" -type f -name "player.blueprints.*.db" -delete | tee -a "${lgsmlog}"
			fn_wipe_exit_code
			fn_sleep_time
		else
			echo -e "no blueprint file to remove"
			fn_sleep_time
			fn_script_log_pass "No blueprint file to remove"
		fi
	elif [ "$(find "${serveridentitydir}" -type f -name "player.blueprints.*.db")" ]; then
			echo -e "keeping blueprints"
			fn_sleep_time
			fn_script_log_info "Keeping blueprints"
	else
			echo -e "no blueprints found"
			fn_sleep_time
			fn_script_log_pass "No blueprints found"
	fi
	# Wipe some logs that might be there.
	if [ "$(find "${serveridentitydir}" -type f -name "Log.*.txt")" ]; then
		echo -en "removing Log files..."
		fn_sleep_time
		fn_script_log "Removing log files: ${serveridentitydir}/Log.*.txt"
		find "${serveridentitydir:?}" -type f -name "Log.*.txt" -delete
		fn_wipe_exit_code
		fn_sleep_time
		# We do not print additional information if there are no logs to remove.
	fi
}

fn_stop_warning(){
	fn_print_warn "this game server will be stopped during wipe"
	fn_script_log_warn "this game server will be stopped during wipe"
	totalseconds=3
	for seconds in {3..1}; do
		fn_print_warn "this game server will be stopped during wipe: ${totalseconds}"
		totalseconds=$((totalseconds - 1))
		sleep 1
		if [ "${seconds}" == "0" ]; then
			break
		fi
	done
	fn_print_warn_nl "this game server will be stopped during wipe"
}

fn_wipe_warning(){
	fn_print_warn "wipe is about to start"
	fn_script_log_warn "wipe is about to start"
	totalseconds=3
	for seconds in {3..1}; do
		fn_print_warn "wipe is about to start: ${totalseconds}"
		totalseconds=$((totalseconds - 1))
		sleep 1
		if [ "${seconds}" == "0" ]; then
			break
		fi
	done
	fn_print_warn "wipe is about to start"
}

fn_print_dots ""
check.sh

# Check if there is something to wipe.
if [ -d "${serveridentitydir}/storage" ]||[ -d "${serveridentitydir}/user" ]||[ -n "$(find "${serveridentitydir}" -type f -name "proceduralmap*.sav")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "barren*.sav")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "Log.*.txt")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "player.deaths.*.db")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "player.blueprints.*.db")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "sv.files.*.db")" ]; then
	fn_wipe_warning
	check_status.sh
	if [ "${status}" != "0" ]; then
		fn_stop_warning
		exitbypass=1
		command_stop.sh
		fn_wipe_server_files
		exitbypass=1
		command_start.sh
	else
		fn_wipe_server_files
	fi
else
	fn_print_info_nl "No data to wipe was found"
	fn_script_log_pass "No data to wipe was found"
fi
core_exit.sh
