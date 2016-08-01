-- redirect stuff like www.zeank.blogsport.de
wpblog =  string.match(lighty.request["Host"], ".+%.([^%.]+)%.blogsport%.de")
if wpblog then
  lighty.header["Location"] = "http://" .. wpblog .. ".blogsport.de" .. lighty.env["request.uri"]
  return 301
end


if string.match(lighty.request["Host"], "^www%.blogsport%.de$") or string.match(lighty.request["Host"], "^main%.blogsport%.de$") then
  lighty.header["Location"] = "http://blogsport.de" .. lighty.env["request.uri"]
  return 301
end


if string.match(lighty.env["uri.path"], "^/wp%-newblog.php$") then
  lighty.header["Location"] = "http://blogsport.de/blog-erstellen/"
  return 301
end


if string.match(lighty.env["uri.path"], "^/wp%-content/blogs/.+/images/.+\.php") then
  return 403
end
if string.match(lighty.env["uri.path"], "^/wp%-inst/wp%-content/blogs/.+/images/.+\.php") then
  return 403
end


cssfile = string.match(lighty.env["uri.path"], "^/wp%-inst/wp%-content/sitetemplates/k2_final/css/(.+).php$")
if cssfile then
 lighty.env["physical.path"] = lighty.env["physical.doc-root"] .. "wp-inst/wp-content/sitetemplates/k2_final/css/" .. cssfile
end


jsdir, jsfile = string.match(lighty.env["uri.path"], "^/plugins/(.+)/(.+).js.php$")
if jsfile then
  if (lighty.stat(lighty.env["physical.doc-root"] .. "wp-inst/wp-content/plugins/"..jsdir.."/"..jsfile..".js") ~= nil) then
    lighty.env["uri.path"] = "/plugins/" .. jsdir .. "/" ..jsfile..".js"
  end
end


minus = string.match(lighty.request["Host"], ".+%-.+%.blogsport%.de")
if minus then
  lighty.header["Location"] = "http://" .. string.gsub(minus, "-", "") .. lighty.env["request.uri"]
  return 301
end

-- grab the blog-id
wpblog = string.match(lighty.request["Host"], "([^%.]+)%.blogsport%.de")

login =  string.match(lighty.env["uri.path"], "^/(wp%-login.php)$")
if login then
     if wpblog then
          lheader = "http://"..wpblog..".blogsport.de/wp-login-2.php"
     else
          lheader = "http://blogsport.de/wp-login-2.php"
     end
     if lighty.env["uri.query"] then
          lheader = lheader .. "?" .. lighty.env["uri.query"]
     end
     lighty.header["Location"]  = lheader
     return 301
end


notrailslash = string.match(lighty.env["uri.path"], ".*/([^/.]+)$")
if notrailslash then
     if wpblog then
          lheader = "http://" .. wpblog .. ".blogsport.de" .. lighty.env["uri.path"] .. "/"
     else
          lheader = "http://blogsport.de" .. lighty.env["uri.path"] .. "/"
     end
     if lighty.env["uri.query"] then
          lheader = lheader .. "?" .. lighty.env["uri.query"]
     end
     lighty.header["Location"]  = lheader
     return 301
end


login = string.match(lighty.env["uri.path"], "^/(wp%-login%-2.php)$")
admin = string.match(lighty.env["uri.path"], "^/wp%-admin") 
image = string.match(lighty.env["uri.path"], "^/images/(.+)$")
template = string.match(lighty.env["uri.path"], "^/templates/(.+)$")
plugin = string.match(lighty.env["uri.path"], "^/plugins/(.+)$")

-- custom redirects
if wpblog and wpblog ~= "www" then
  wpblog = string.lower(wpblog)
  userfolder = lighty.env["physical.doc-root"] .. "wp-inst/wp-content/blogs/" .. wpblog
  if not admin and not login and not image and not plugin and not template and lighty.stat(userfolder .. "/.redirectActive") ~= nil then
    file = assert(io.open(userfolder .. "/.redirectActive", "r"))
    target = file:read():match "https?:%/%/%S+%.%S+"
    file:close()
    if lighty.stat(userfolder .. "/.redirectWithPath") ~= nil then
      -- remove trailing slash
      if target:find("/", #target) then
        target = target:sub(1, -2)
      end
      lighty.header["Location"] = target  .. lighty.env["request.uri"]
    else
      lighty.header["Location"] = target
    end
    if lighty.stat(userfolder .. "/.redirect301") ~= nil then
      return 301
    else
      return 302
    end
  end
else
  if (string.match(lighty.request["Host"], "barrikade%-moers%.de")) then
    wpblog = "barrikade"
  else if (string.match(lighty.request["Host"], "stop%-g7%-elmau%.info")) then
    wpblog = "stopg7elmau"
  else if (string.match(lighty.request["Host"], "rojava%-solidaritaet%.net")) then
    wpblog = "rojavasupport"
  else if (string.match(lighty.request["Host"], "klima%-macht%-flucht%.net")) then
    wpblog = "klimamachtflucht"
  else if (string.match(lighty.request["Host"], "klimamachtflucht%.net")) then
    wpblog = "klimamachtflucht"
  else
    wpblog = "main" -- needed for rel-path below
  end
  end
  end
  end
  end
  userfolder = lighty.env["physical.doc-root"] .. "wp-inst/wp-content/blogs/" .. wpblog
end


if lighty.env["uri.query"] then
  lighty.env["uri.query"] = lighty.env["uri.query"] .. "&wpblog=" .. wpblog
else
  lighty.env["uri.query"] = "wpblog=" .. wpblog
end

if wpblog ~= "main" and not admin and not login and not plugin and not template and lighty.stat(userfolder .. "/.blocked") ~= nil then
  lighty.env["physical.path"] = "/home/blogsport/gesperrt.blogsport.de/index.php"
else if (not lighty.stat(lighty.env["physical.path"])) then
  lighty.env["physical.doc-root"] = lighty.env["physical.doc-root"] .. "wp-inst/"


  -- skip main
  main = string.match(lighty.env["uri.path"], "^/main(/.+)$")
  if main then
    lighty.env["uri.path"] = main
  end


  register = string.match(lighty.env["uri.path"], "^/blog%-erstellen/$")
  if wpblog == 'main' and register then
    lighty.env["physical.rel-path"] = "wp-newblog.php"
  end


  if plugin then
    lighty.env["physical.rel-path"] = "wp-content/plugins/"..plugin
  end
  if template then
    lighty.env["physical.rel-path"] = "wp-content/blogs/" .. wpblog .. "/templates/" .. template
  end
  if image then
    if string.match(image, ".+\.php$") then
      return 403
     else
      lighty.env["physical.rel-path"] = "wp-content/blogs/" .. wpblog .. "/images/" .. image
    end
  end
  if (not register and not plugin and not image and not template) then 
    wp1, wp2 = string.match(lighty.env["uri.path"], "^(/?[^/]*)/(wp%-.*)$")
    if wp2 then
      lighty.env["physical.rel-path"] = wp1.."/"..wp2;
    else
      n, a = string.match(lighty.env["uri.path"], "^(/?[^/]*/)(.*\.php)$")
      if a then
        -- a php page
        lighty.env["physical.rel-path"] = a
      else
     -- that's where we do the fancy rewrite stuff
     -- lighty.env["uri.path"] contains whats left to process
     category, path = string.match(lighty.env["uri.path"], "^/category/?([^/]*)(/?.*)$")
     if category then
       lighty.env["uri.query"] = lighty.env["uri.query"] .. "&category_name=" .. category
       lighty.env["uri.path"] = path
     end
     author, path = string.match(lighty.env["uri.path"], "^/author/?([^/]*)(/?.*)$")
     if author then
       lighty.env["uri.query"] = lighty.env["uri.query"] .. "&author_name=" .. author
       lighty.env["uri.path"] = path
     end
     path, feed = string.match(lighty.env["uri.path"], "^(.*)/feed/([_0-9a-z-]*)/?$")
     if feed then
       lighty.env["physical.rel-path"] = "wp-feed.php"
       if (feed == "") then
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&feed=rss2"
       else
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&feed=" .. feed
       end
       if string.match(lighty.env["uri.path"], "/comments/feed") then
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&withcomments=1"
         path = ""
       end
       lighty.env["uri.path"] = path
     else
       -- not a feed
       lighty.env["physical.rel-path"] = "index.php"
       path, page = string.match(lighty.env["uri.path"], "^(.*)/page/?([0-9]*)/?$")
       if page then
         lighty.env["uri.path"] = path
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&paged=" .. page
       end
       tag = string.match(lighty.env["uri.path"], "^/tag/(.*)/$")
       if tag then
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&tag=" .. tag
         lighty.env["uri.path"] = ""
       end
     end
     year, path = string.match(lighty.env["uri.path"], "^/(%d%d%d%d)/(.*)$")
     if year then
       lighty.env["uri.path"] = path
       lighty.env["uri.query"] = lighty.env["uri.query"] .. "&year=" .. year
       monthnum, path = string.match(lighty.env["uri.path"], "^(%d%d?)/?(.*)$")
       if monthnum then
         lighty.env["uri.path"] = path
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&monthnum=" .. monthnum
         day, path = string.match(lighty.env["uri.path"], "^(%d%d?)/?(.*)$")
         if day then
           lighty.env["uri.path"] = path
           lighty.env["uri.query"] = lighty.env["uri.query"] .. "&day=" .. day
         end
       end
         name, page = string.match(lighty.env["uri.path"], "^([_0-9a-z-]+)/?(%d*)/?$")
         if name then
               lighty.env["uri.query"] = lighty.env["uri.query"] .. "&name=" .. name
             if page then
               lighty.env["uri.query"] = lighty.env["uri.query"] .. "&page=" .. page
             end
         end
     else
       pagename, page = string.match(lighty.env["uri.path"], ".*/([^/]+)/(%d+)/$")     
          if pagename ~= nil and page ~=nil then
         lighty.env["uri.query"] = lighty.env["uri.query"] .. "&pagename=" .. pagename .. "&page=" .. page
       else
            pagename = string.match(lighty.env["uri.path"], ".*/([^/]+)/$")
            if pagename then
           lighty.env["uri.query"] = lighty.env["uri.query"] .. "&pagename=" .. pagename
            end
       end
     end
      end
    end
  end


  -- print(lighty.env["uri.query"])


  if string.match(lighty.env["uri.path"], "^/smilies") then
    -- fix smilies
    lighty.env["physical.rel-path"] = lighty.env["uri.path"]
  end
  lighty.env["physical.path"] = lighty.env["physical.doc-root"] .. lighty.env["physical.rel-path"]
else
  if (not string.match(lighty.env["physical.rel-path"], "^/wp%-inst/")) then
    -- unfortunately we must skip htdocs/index.php, maybe some day there's a better solution by completely moving wp-inst/* to ..
    lighty.env["physical.path"] = lighty.env["physical.doc-root"] .. "wp-inst" .. lighty.env["physical.rel-path"]
  end
end
end
