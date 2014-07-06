###*
 * 200 (OK) Response
 *
 * Usage:
 * return res.ok();
 * return res.ok(data);
 * return res.ok(data, view);
 * return res.ok(data, redirectTo);
 * return res.ok(data, true);
 *
 * @param  {Object} data
 * @param  {Boolean|String} viewOrRedirect
 *         [optional]
 *          - pass string to render specified view
 *          - pass string with leading slash or http:// or https:// to do redirect
 ###

module.exports = sendOK = (data, viewOrRedirect) ->

  # Get access to `req` & `res`
  req = @req
  res = @res

  # Serve JSON (with optional JSONP support)
  sendJSON = (data) ->
    unless data
      return res.send()
    else
      if typeof data isnt 'object'
        return res.send data
      if ( req.options.jsonp and !req.isSocket )
        return res.jsonp data
      else return res.json data

  # Set status code
  res.status 200

  # Log error to console
  @req._sails.log.verbose 'Sent 200 ("OK") response'
  if data
    @req._sails.log.verbose data

  # Serve JSON (with optional JSONP support)
	if req.wantsJSON
		return sendJSON data

  # Make data more readable for view locals
  locals = {}
  if (!data or typeof data isnt 'object')
    locals = {}
  else
    locals = data

  # Serve HTML view or redirect to specified URL
  if typeof viewOrRedirect is 'string'
    if viewOrRedirect.match(/^(\/|http:\/\/|https:\/\/)/)
      return res.redirect viewOrRedirect
    else return res.view viewOrRedirect, locals, (viewErr, html) ->
      if viewErr
        return sendJSON data
      else return res.send html
  else return res.view locals, (viewErr, html) ->
    if viewErr
      return sendJSON data
    else return res.send html
