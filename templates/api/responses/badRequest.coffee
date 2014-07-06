###*
 * 400 (Bad Request) Handler
 *
 * Usage:
 * return res.badRequest();
 * return res.badRequest(err);
 * return res.badRequest(err, view);
 * return res.badRequest(err, redirectTo);
 *
 * e.g.:
 * ```
 * return res.badRequest(
 *   'Please choose a valid `password` (6-12 characters)',
 *   '/trial/signup'
 * );
 * ```
 ###

module.exports = badRequest = (err, viewOrRedirect) ->

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
      if (req.options.jsonp and !req.isSocket)
        return res.jsonp data
      else return res.json data

  # Set status code
  res.status 400

  # Log error to console
  @req._sails.log.verbose 'Sent 400 ("Bad Request") response'
  if err
    @req._sails.log.verbose err

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
      if (err and typeof req.flash is 'function')
        req.flash 'error', err
      return res.redirect viewOrRedirect
    else return res.view viewOrRedirect, locals, (viewErr, html) ->
      if viewErr
        return sendJSON err
      else return res.send html
  else return res.view '400', locals, (viewErr, html) ->
    if viewErr
      return sendJSON err
    else return res.send html
