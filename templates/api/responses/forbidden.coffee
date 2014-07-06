###*
 * 403 (Forbidden) Handler
 *
 * Usage:
 * return res.forbidden();
 * return res.forbidden(err);
 * return res.forbidden(err, view);
 * return res.forbidden(err, redirectTo);
 *
 * e.g.:
 * ```
 * return res.forbidden('Access denied.');
 * ```
 ###

module.exports = forbidden = (err, viewOrRedirect) ->

  # Get access to `req` & `res`
  req = @req
  res = @res

  # Serve JSON (with optional JSONP support)
  sendJSON = (data) ->
    unless data
      return res.send()
    else
      if (typeof data isnt 'object' or data instanceof Error)
        data = error: data
      if ( req.options.jsonp and !req.isSocket )
        return res.jsonp data
      else return res.json data

  # Set status code
  res.status 403

  # Log error to console
  @req._sails.log.verbose 'Sent 403 ("Forbidden") response'
  if err
    @req._sails.log.verbose(err)

  # If the user-agent wants JSON, always respond with JSON
  if req.wantsJSON
    return sendJSON err

  # Make data more readable for view locals
  locals = {}
  unless err
    locals = {}
  else if (typeof err isnt 'object')
    locals = error: err
  else
    readabilify = (value) ->
      if sails.util.isArray(value)
        return sails.util.map value, readabilify
      else if sails.util.isPlainObject(value)
        return sails.util.inspect value
      else return value
    locals = error: readabilify(err)

    # Serve HTML view or redirect to specified URL
  if typeof viewOrRedirect is 'string'
    if viewOrRedirect.match(/^(\/|http:\/\/|https:\/\/)/)
      return res.redirect viewOrRedirect
    else return res.view viewOrRedirect, locals, (viewErr, html) ->
      if viewErr
        return sendJSON err
      else return res.send html
  else return res.view '403', locals, (viewErr, html) ->
    if viewErr
      return sendJSON err
    else return res.send html
