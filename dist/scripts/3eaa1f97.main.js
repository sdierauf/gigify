(function(){var a,b,c,d,e,f,g,h,i,j,k,l,m;c="fWhzvRX8MxP35pNx",a="CXWHF3RAFXNLY9EHI",d="http://api.eventful.com/json/events/search",b="http://developer.echonest.com/api/v4/playlist/static",e=["January","February","March","April","May","June","July","August","September","October","November","December"],l=!1,$(document).ready(function(){return $("#search-bar").keypress(function(a){return 13===a.which?(h(this.value),l=!0):void 0})}),h=function(a){return $.ajax({url:d,type:"GET",dataType:"jsonp",data:{app_key:c,where:a,category:"music",sort_order:"popularity"},success:j})},j=function(a){var b,c,d,e,g,h,j,k,l,n,o,p,q,r,s,t;for(d=[],e=[],s=a.events.event,o=0,q=s.length;q>o;o++){if(c=s[o],h=c.city_name+", "+c.region_abbr,n=c.venue_name,b=m(c.start_time),l=c.url,g=c.image.url.replace("small","block250"),k=[],c.performers)if(c.performers.performer instanceof Array)for(t=c.performers.performer,p=0,r=t.length;r>p;p++)j=t[p],k.push(j.name),d.push("eventful:artist:"+j.id);else k.push(c.performers.performer.name),d.push("eventful:artist:"+c.performers.performer.id);e.push({location:h,venue:n,date:b,url:l,image:g,performers:k})}return f(e),i(d.unique().slice(0,5)),i(d.unique().slice(5,10))},f=function(a){var b,c,d,e,f,g,h,i,j;for(l&&($("#upcoming-shows-header").remove(),$(".event").remove()),f=$("<h2 />",{id:"upcoming-shows-header",html:"<hr>Upcoming Shows"}),f.hide().insertAfter("#spotify-player").fadeIn(1e3),j=[],h=0,i=a.length;i>h;h++)e=a[h],d=$("<div />",{"class":"event col-sm-6 center-block"}),b=$("<a />",{"class":"event-image-shadow"}),g=$("<img />",{src:e.image,"class":"event-image"}),c=$("<div />",{"class":"event-body",html:'<span class="event-performer">'+e.performers.join(", ")+'</span><br><span class="event-venue">'+e.venue+'</span><br><span class="event-location">'+e.location+'</span><br><a href="'+e.url+'"><span class="event-date">'+e.date+"</span></a>"}),b.append(g),d.append(b).append(c),j.push(d.hide().appendTo("#events").fadeIn(1e3));return j},i=function(c){return $.ajax({url:b,type:"GET",dataType:"jsonp",traditional:"true",data:{api_key:a,artist:c,variety:1,format:"jsonp",results:20,type:"artist",bucket:["id:spotify-US","tracks","audio_summary"],adventurousness:0},success:k})},k=function(a){var b,c,d,e,f;for(c=[],f=a.response.songs,d=0,e=f.length;e>d;d++)b=f[d],b.tracks.length&&c.push(b.tracks[0].foreign_id.split(":")[2]);return g(c)},g=function(a){var b;return $("#spotify-player").empty(),l&&$("#spotify-frame").remove(),b=$("#spotify-frame"),0!==b.length?b.appendAttr("src",","+a.join(",")):$("<iframe />",{src:"https://embed.spotify.com/?theme=white&&view=coverart&uri=spotify:trackset:Gigify:"+a.join(","),frameborder:"0",allowtransparency:"true",id:"spotify-frame"}).hide().appendTo("#spotify-player").fadeIn(1e3)},Array.prototype.unique=function(){var a,b,c,d,e,f;for(b={},a=d=0,e=this.length;e>=0?e>d:d>e;a=e>=0?++d:--d)b[this[a]]=this[a];f=[];for(a in b)c=b[a],f.push(c);return f},$.fn.appendAttr=function(a,b){return this.attr(a,function(a,c){return c+b}),this},m=function(a){var b,c,d;return a=a.split(" ")[0],d=a.split("-")[0],c=a.split("-")[1],b=a.split("-")[2],""+e[parseInt(c)-1]+" "+b+", "+d}}).call(this);