proc(_ticket_dispatch, @input,
    assign(@match, reg_match('^\\s*([^ ]+)(\\s+(.*)\\s*)?$', @input))
    if(!@match == array()) {
        assign(@first, to_lower(@match[1]))
        assign(@args, @match[3])
    }
    switch(@first,
    	'write',
    		_CHticket_check_perm('write')
    		assign(@Tickets, _fetch_tickets())
    		if(_CHticket_perm(write.vip)) {
    			assign(@priority, 'High')
    		} else {
    			assign(@priority, 'Normal')
    		}
    		assign(@Ticket, _form_ticket(@args, @priority))
            array_push(@Tickets, @Ticket)
            _store_tickets(@Tickets)
            msg(color(green). 'Ticket submitted Succesfully!'),
        'list',
            assign(@Tickets, _fetch_tickets())
            if(array_size(@Tickets) == 0) {
                die(color(Red).'No Tickets')
            } else {
                msg(color(Green).'Tickets:')
            }
            assign(@ID, 0)
            foreach(@Tickets, @Ticket, msg(_view_ticket(ID Title, @ID)) @ID++)
    )
)
