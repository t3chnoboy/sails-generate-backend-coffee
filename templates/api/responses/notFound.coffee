###*
 * 404 (Not Found) Handler
 *
 * Usage:
 * return res.notFound();
 * return res.notFound(err);
 * return res.notFound(err, view);
 * return res.notFound(err, redirectTo);
 *
 * e.g.:
 * ```
 * return res.notFound();
 * ```
 *
 * NOTE:
 * If a request doesn't match any explicit routes (i.e. `config/routes.js`)
 * or route blueprints (i.e. "shadow routes", Sails will call `res.notFound()`
 * automatically.
 ###

module.exports =  notFound = (err, viewOrRedirect) ->

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
  res.status 404

  # Log error to console
  @req._sails.log.verbose 'Sent 404 ("Not Found") response'
  if err
    @req._sails.log.verbose err

  # If the user-agent wants JSON, always respond with JSON
  if req.wantsJSON
    return sendJSON err

  # Make data more readable for view locals
  locals = {}
  unless err
    locals = {}
  else if typeof err isnt 'object'
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
  else return res.view '404', locals, (viewErr, html) ->
    if viewErr
      return sendJSON err
    else return res.send html
