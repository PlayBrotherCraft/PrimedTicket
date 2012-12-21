proc(_CHticket_perm, @perm,
    assign(@perms, 'chticket.'.@perm)
    ifelse(
    	player() == '~console',
    		return(true),
    	pisop(),
    		return(true),
    	has_permission(@perms),
    		return(true),
    	#else
    		return(false)
    )
)

proc(_CHticket_check_perm, @perm, assign(@state, true),
	if(_CHticket_perm, @perm) {
	if(@state == true) {console(player() 'tried permission - chticket.'.@perm, false)}
	die(color(RED). 'You don\'t have permissions')
	}
)

proc(_CHticket_procError, @error,
	ifelse(
		@error == 'fixed error',
			die(color(Red). 'An error occurred that has been fixed please redo your last ticket action')
	)
)

proc(_fetch_tickets,
	assign(@Tickets, get_value('ACzChef.CHTicket.Tickets'))
	#if there is an empty value fix it
	if(is_null(@Tickets)) {
		assign(@Tickets, array(array(
			'player': 'null',
			'Title': 'Error',
			'Desc': 'Delete This Ticket It Was To Fix The System',
			'Location': 'null',
			'Date': 'null',
			'Priority': 'null',
			'Notes': 'null'
		)))
		store_value('ACzChef.CHTicket.Tickets', @Tickets)
		_CHticket_procError(fixed error)
	}
	return(@Tickets)
)

proc(_form_ticket, @info, @priority,
	assign(@info, reg_match('^\\s*([^ ]+)(\\s+(.*)\\s*)?$', @info))
	assign(@title, @info[1])
	assign(@desc, to_lower(@info[3]))
	assign(@ticket, array(
		'Player': player(),
		'Title': @title,
		'Desc': @desc,
		'Location': ploc(),
		'Date': simple_date('MM/dd/yy'),
		'Priority': @priority,
		'Notes': array()
	))
	return(@ticket)
)

proc(_view_ticket, @type, @Index,
	if(!(@type == 'ID Title' || @type == 'All Info' )) {
		console(color(Red). 'proc _view_ticket must be an "IF Title" or "All Info".')
		die()
	}
	assign(@Tickets, _fetch_tickets())
	assign(@Ticket, @Tickets[@Index])
	if(@type == 'ID Title') {
		return('['.@Index.'] -'@Ticket['Title'])
	}
)

proc(_store_tickets, @Tickets,
	store_value('ACzChef.CHTicket.Tickets', @Tickets)
)
include('dispatch.ms')