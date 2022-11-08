--[[




--]]
URL     = require("./libs/url")
JSON    = require("./libs/dkjson")
serpent = require("libs/serpent")
json = require('libs/json')
Redis = require('libs/redis').connect('127.0.0.1', 6379)
http  = require("socket.http")
https   = require("ssl.https")
local Methods = io.open("./luatele.lua","r")
if Methods then
URL.tdlua_CallBack()
end

-------------------------------------------------------------------
SshId = io.popen("echo $SSH_CLIENT ︙ awk '{ print $1}'"):read('*a')
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
luatele = require 'luatele'
local FileInformation = io.open("./Information.lua","r")
if not FileInformation then
if not Redis:get(SshId.."Info:Redis:Token") then
io.write('\27[1;31mارسل لي توكن البوت الان \nSend Me a Bot Token Now ↡\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getMe')
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mعذرا توكن البوت خطأ تحقق منه وارسله مره اخره \nBot Token is Wrong\n')
else
io.write('\27[1;34mتم حفظ التوكن بنجاح \nThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .CallBack-Bot/'..TheTokenBot)
Redis:del(SshId.."Info:Redis:Token")
Redis:set(SshId.."Info:Redis:Token",TokenBot)
Redis:set(SshId.."Info:Redis:Token:User",Json_Info.result.username)
end 
else
print('\27[1;34mلم يتم حفظ التوكن جرب مره اخره \nToken not saved, try again')
end 
os.execute('lua NASA.lua')
end
if not Redis:get(SshId.."Info:Redis:User") then
io.write('\27[1;31mارسل معرف المطور الاساسي الان \nDeveloper UserName saved ↡\n\27[0;39;49m')
local UserSudo = io.read():gsub('@','')
if UserSudo ~= '' then
io.write('\n\27[1;34mتم حفظ معرف المطور \nDeveloper UserName saved \n\n\27[0;39;49m')
Redis:del(SshId.."Info:Redis:User")
Redis:set(SshId.."Info:Redis:User",UserSudo)
else
print('\n\27[1;34mلم يتم حفظ معرف المطور الاساسي \nDeveloper UserName not saved\n')
end 
os.execute('lua NASA.lua')
end
if not Redis:get(SshId.."Info:Redis:User:ID") then
io.write('\27[1;31mارسل ايدي المطور الاساسي الان \nDeveloper ID saved ↡\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('(%d+)') then
io.write('\n\27[1;34mتم حفظ ايدي المطور \nDeveloper ID saved \n\n\27[0;39;49m')
Redis:del(SshId.."Info:Redis:User:ID")
Redis:set(SshId.."Info:Redis:User:ID",UserId)
else
print('\n\27[1;34mلم يتم حفظ ايدي المطور الاساسي \nDeveloper ID not saved\n')
end 
os.execute('lua NASA.lua')
end
local Informationlua = io.open("Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..Redis:get(SshId.."Info:Redis:Token")..[[",
UserBot = "]]..Redis:get(SshId.."Info:Redis:Token:User")..[[",
UserSudo = "]]..Redis:get(SshId.."Info:Redis:User")..[[",
SudoId = ]]..Redis:get(SshId.."Info:Redis:User:ID")..[[
}
]])
Informationlua:close()
local NASA = io.open("NASA", 'w')
NASA:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 NASA.lua
done
]])
NASA:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Redis:get(SshId.."Info:Redis:User")..[[ -X kill
screen -S ]]..Redis:get(SshId.."Info:Redis:User")..[[ ./NASA
done
]])
Run:close()
Redis:del(SshId.."Info:Redis:User:ID");Redis:del(SshId.."Info:Redis:User");Redis:del(SshId.."Info:Redis:Token:User");Redis:del(SshId.."Info:Redis:Token")
os.execute('chmod +x NASA;chmod +x Run;./Run')
os.execute('rm -fr $HOME/.CallBack-Bot')
end
Information = dofile('./Information.lua')
Sudo_Id = Information.SudoId
UserSudo = Information.UserSudo
Token = Information.Token
UserBot = Information.UserBot
NASA = Token:match("(%d+)")
os.execute('sudo rm -fr .CallBack-Bot/'..NASA)
LuaTele = luatele.set_config{api_id=19435384,api_hash='7fbb46e74c27e4ae1f6be41d52fe7e2e',session_name=NASA,token=Token}
function var(value)
print(serpent.block(value, {comment=false}))   
end 
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
clock = os.clock
function sleep(n)
local t0 = clock()
while clock() - t0 <= n do end
end
function Dev(msg) 
if tonumber(msg.sender_id.user_id) == tonumber(Sudo_Id)  or Redis:sismember(NASA.."Dev",msg.sender_id.user_id) then
ok = true
else
ok = false
end
return ok
end

function chat_type(ChatId)
if ChatId then
local id = tostring(ChatId)
if id:match("-100(%d+)") then
Chat_Type = 'GroupBot' 
elseif id:match("^(%d+)") then
Chat_Type = 'UserBot' 
else
Chat_Type = 'GroupBot' 
end
end
return Chat_Type
end
function Run(msg,data)  
local msg_chat_id = msg.chat_id
local msg_reply_id = msg.reply_to_message_id
local msg_user_send_id = msg.sender_id.user_id
local msg_id = msg.id
if data.content.text then
text = data.content.text.text
else 
text = nil
end
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end

function ChannelJoin(id)
JoinChannel = true
local chh = Redis:get(NASA.."chfalse")
if chh then
local url = https.request("https://api.telegram.org/bot"..Token.."/getchatmember?chat_id="..chh.."&user_id="..id)
data = json:decode(url)
if data.result.status == "left" or data.result.status == "kicked" then
JoinChannel = false 
end
end 
return JoinChannel
end
function send(chat,rep,text,parse,dis,clear,disn,back,markup)
LuaTele.sendText(chat,rep,text,parse,dis, clear, disn, back, markup)
end
if tonumber(msg.sender_id.user_id) == tonumber(NASA) then
print('This is reply for Bot')
return false
end
function Reply_Status(UserId,TextMsg)
local UserInfo = LuaTele.getUser(UserId)
Name_User = UserInfo.first_name
if Name_User then
UserInfousername = '['..Name_User..'](tg://user?id='..UserId..')'
else
UserInfousername = UserId
end
return {
Lock     = '\n*◍ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n◍خاصيه المسح *',
unLock   = '\n*◍ بواسطه ← *'..UserInfousername..'\n'..TextMsg,
lockKtm  = '\n*◍ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n◍خاصيه الكتم *',
lockKid  = '\n*◍ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n◍خاصيه التقييد *',
lockKick = '\n*◍ بواسطه ← *'..UserInfousername..'\n*'..TextMsg..'\n◍خاصيه الطرد *',
Reply    = '\n*◍ المستخدم ← *'..UserInfousername..'\n*'..TextMsg..'*'
}
end

if Dev(msg) then
if text == "تحديث" or text == "♻️ | تحديث الصانع" then
LuaTele.sendText(Sudo_Id,0,"تم تحديث ملف المصنع بنجاح✅")
dofile('NASA.lua')  
return false 
end
if text == "🔄 | تحديث المصنوعات" then
Redis:del(NASA..'3ddbots')
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
os.execute('cp -a ./NAMNASA/. ./'..folder..' && cd '..folder..' &&chmod +x * && screen -X -S '..folder:gsub("@","")..' quit && screen -d -m -S '..folder:gsub("@","")..' ./Run')
Redis:sadd(NASA..'3ddbots',folder)
end
end
os.execute('cp -a ./NAMNASA/. ./MKNASA')
allb = Redis:smembers(NASA..'3ddbots')
send(msg.chat_id,msg.id,"*تم تحديث :- `"..#allb.."` *\nمن البوتات","md",true)  
end
if msg.reply_to_message_id ~= 0 then
local Message_Get = LuaTele.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
local Info_User = Redis:get(NASA.."Twasl:UserId"..Message_Get.forward_info.date) or 46899864
if text == 'حظر' then
Redis:sadd(NASA..'BaN:In:Tuasl',Info_User)  
return send(msg.chat_id,msg.id,Reply_Status(Info_User,'*عـزيـزي الـمـطـور بانـدا تم حظره من الـصانـع بنجاح .*').Reply,"md",true)  
end 
if text =='الغاء الحظر' or text =='الغاء حظر' then
Redis:srem(NASA..'BaN:In:Tuasl',Info_User)  
return send(msg.chat_id,msg.id,Reply_Status(Info_User,'*عـزيـزي الـمـطـور بانـدا تم الـغاء حظره من الـصانـع بنجاح .*').Reply,"md",true)  
end 
end
end

if text == "• الغاء الامر •" or text == "الغاء" then
Redis:del(NASA..msg.sender_id.user_id.."bottoken")
Redis:del(NASA..msg.sender_id.user_id.."botuser")
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
Redis:del(NASA..msg.sender_id.user_id.."brodcast")
Redis:del(NASA.."all:texting:pv")
Redis:del(NASA.."all:texting")
Redis:del(NASA.."KN:OPAll")
Redis:del(NASA.."all:BanAll")
Redis:del(NASA..msg.sender_id.user_id.."brodcast:fwd")
return send(msg.chat_id,msg.id,"*◍ تـم الـغاء الامـر بنـجاح ..*","md")
end

if text == "/start" or text == "🔚 | القائمه الرئيسيه"then 
Redis:del(NASA..msg.sender_id.user_id.."bottoken")
Redis:del(NASA..msg.sender_id.user_id.."botuser")
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
Redis:del(NASA..msg.sender_id.user_id.."brodcast")
Redis:del(NASA.."all:texting:pv")
Redis:del(NASA.."all:texting")
Redis:del(NASA..msg.sender_id.user_id.."brodcast:fwd")
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '✅ | صنع بوت',type = 'text'},{text = '❎ | حذف بوت',type = 'text'},
},
{
{text = '🛡️ | حظر عام',type = 'text'},{text = '🛡️ | الغاء العام',type = 'text'},
},
{
{text = '⏺️ | قسم الاذاعه',type = 'text'},{text = '⏺️ | قسم المصنع',type = 'text'},
},
{
{text = '⏺️ | قسم التفعيل',type = 'text'},
},
{
{text = '🤖 | توب البوتات ',type = 'text'},
},
{
{text = 'الاسكرينات المفتوحه 📂',type = 'text'},
},
{
{text = '♻️ | تحديث الصانع',type = 'text'},{text = '🔄 | تحديث المصنوعات',type = 'text'},
},
{
{text = '• الغاء الامر •',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,"*◍ اهلاً بك عـزيـري الـمـطور بانـدا* \n","md",true, false, false, true, reply_markup)
return false 
end
if text == "⏺️ | قسم الاذاعه" then 
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '📢 | إذاعه عام للمجموعات',type = 'text'},{text = '📮 | إذاعه عام للمشتركين',type = 'text'},
},
{
{text = '📡 | اذاعه',type = 'text'},{text = '🧭 | اذاعه بالتوجيه',type = 'text'},
},
{
{text = '📀 | اذاعه عام تثبيت',type = 'text'},{text = '💿 | اذاعه عام بالتوجيه',type = 'text'},
},
{
{text = '• الغاء الامر •',type = 'text'},
},
{
{text = '🔚 | القائمه الرئيسيه',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,"*◍ اهلاً بك عـزيـري الـمـطور بانـدا* \n","md",true, false, false, true, reply_markup)
return false 
end
if text == "⏺️ | قسم المصنع" then 
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '✴️ | المشتركين',type = 'text'},{text = '🧲 | جلب نسخه',type = 'text'},
},
{
{text = '🔂 | قائمة الوهمي',type = 'text'},{text = '🔬 | تنظيف الوهمي',type = 'text'},
},
{
{text = '🔍 | عدد المصنوعات',type = 'text'},{text = '🔎 | احصائيات المصنوعات',type = 'text'},
},
{
{text = '🔚 | القائمه الرئيسيه',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,"*◍ اهلاً بك عـزيـري الـمـطور بانـدا* \n","md",true, false, false, true, reply_markup)
return false 
end
if text == "⏺️ | قسم التفعيل" then 
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '💾 | تشغيل بوت',type = 'text'},{text = '🗑️ | إيقاف بوت',type = 'text'},
},
{
{text = '◀️ | تشغيل الصانع',type = 'text'},{text = '⏸️ | تعطيل الصانع',type = 'text'},
},
{
{text = '🔓 | تفعيل التواصل',type = 'text'},{text = '🔒 | تعطيل التواصل',type = 'text'},
},
{
{text = '☢️ | تفعيل الإجباري',type = 'text'},{text = '⚠️ | تعطيل الإجباري',type = 'text'},
},
{
{text = '🔚 | القائمه الرئيسيه',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,"*◍ اهلاً بك عـزيـري الـمـطور زيزو* \n","md",true, false, false, true, reply_markup)
return false 
end

------
if text and text:match("^رفع مطور (%d+)$") then
Redis:sadd(NASA.."Dev",text:match("^رفع مطور (%d+)$"))
send(msg.chat_id,msg.id,'◍ تم رفع العضو مطور ف الصانع بنجاح ',"md",true)  
return false 
end
if text and text:match("^تنزيل مطور (%d+)$") then
Redis:sadd(NASA.."Dev",text:match("^تنزيل مطور (%d+)$"))
send(msg.chat_id,msg.id,'◍ تم تنزيل العضو مطور من الصانع بنجاح ',"md",true)  
return false 
end
-----

if text == "◀️ | تشغيل الصانع" then 
Redis:del(NASA.."free:bot")
send(msg.chat_id,msg.id,'*◍ تم تشغيل بوت الصانع، يمكن للمستخدمين صنع بوتاتهم الآن ..*',"md",true)  
end
if text == "⏸️ | تعطيل الصانع" then 
Redis:set(NASA.."free:bot",true)
send(msg.chat_id,msg.id,'*◍ تم ايقاف صنع البوتات في المصنع، لن يتمكن احد من استخدام الصانع في الوقت الحالي ..*',"md",true)  
end
--------------------------------------------------------------------------------------------------------------
if text == "الاسكرينات المفتوحه 📂" then  
rqm = 0
local message = ' ◍  السكرينات الموجوده بالسيرفر \n\n'
for screnName in io.popen('ls /var/run/screen/S-root'):lines() do
rqm = rqm + 1
message = message..rqm..'-  { '..screnName..' }\n'
end
send(msg.chat_id,msg.id,message..'\n حاليا عندك '..rqm..' اسكرين مفتوح ...\n',"html",true)
return false
end
if text == "تشغيل البوتات" then
Redis:del(NASA..'3ddbots')
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
os.execute('cd '..folder..' && chmod +x * && screen -d -m -S '..folder:gsub("@","")..' ./Run')
Redis:sadd(NASA..'3ddbots',folder)
end
end
local list = Redis:smembers(NASA..'3ddbots')
send(msg.chat_id,msg.id,"تم تشغيل "..#list.." بوت","html",true)  
end

-----By BaNdA
if text == "🔎 | احصائيات المصنوعات" or text == "فحص" then
Redis:del(NASA.."All:pv:st")
Redis:del(NASA.."All:gp:st")
txx = "📊 الـيك جمـيع احصائيات البوتات المصنوعة"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
Redis:incrby(NASA.."All:gp:st",tonumber(#list))
Redis:incrby(NASA.."All:pv:st",tonumber(#lt))
end
end
send(msg.chat_id,msg.id,'\n◍ احصائيات جميع البوتات المصنوعه \n ◍ عدد المجموعات '..Redis:get(NASA.."All:gp:st")..' مجموعه \n◍ عدد المشتركين '..Redis:get(NASA.."All:pv:st")..' مشترك',"md",true)
end
----By BaNdA
if text == "🔬 | تنظيف الوهمي" or text == "حذف الوهمي" then
Redis:del(NASA.."fake")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
if #list < 2 then
Redis:sadd(NASA.."fake",botuser )
os.execute("sudo rm -fr "..botuser)
os.execute('screen -X -S '..botuser:gsub("@","")..' quit')
end
end
end
local list = Redis:smembers(NASA..'fake')
send(msg.chat_id,msg.id,"◍ تم ايقاف "..#list.." بوت \n عدد مجموعاتهم اقل من 2","md",true)
end
if text == "🔂 | قائمة الوهمي" or text == "الوهمي" then
local txx = "اليك قائمة البوتات الوهمية! \n"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
if #list < 2 then
txx = txx.."◍ "..botuser.." » "..#list.."\n"
end
end
end
send(msg.chat_id,msg.id,"["..txx.."]","md",true)
end
if text == "🤖 | توب البوتات" then
local txx = "اليك قائمة البوتات ! \n"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
lt = Redis:smembers(bot_id.."Num:User:Pv") 
if #list > 10 then
txx = txx.."◍ "..botuser.." » "..#list.."\n"
end
end
end
send(msg.chat_id,msg.id,"["..txx.."]","md",true)
end
if text == "🔍 | عدد المصنوعات" then
Redis:del(NASA..'3ddbots')
bots = "\nقائمه البوتات\n"
botat = "\nقائمه البوتات\n"
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
Redis:sadd(NASA..'3ddbots',botuser..' » '..devbot)
end
end
local list = Redis:smembers(NASA..'3ddbots')
if #list <= 100 then
for k,v in pairs(list) do
bots = bots..' '..k..'-'..v..'\n'
end
else
for k = 1,100 do
bots = bots..' '..k..'-'..list[k]..'\n'
end
for i = 101 , #list do
botat = botat..' '..i..'-'..list[i]..'\n'
end
end
if #list <= 100 then
send(msg.chat_id,msg.id,"["..bots.."]\n".."وعددهم "..#list.."","md",true)  
else
send(msg.chat_id,msg.id,"["..bots.."]","md",true)
send(msg.chat_id,msg.id,botat.."\n".."وعددهم "..#list.."","md",true)  
end
end
------By BaNdA
-----تشغيل البوتات ---
if text and Redis:get(NASA..msg.sender_id.user_id.."run:bot") then
Redis:del(NASA..msg.sender_id.user_id.."run:bot")
Redis:del(NASA.."screen:on")
Redis:del(NASA.."bots:folder")
userbot = text:gsub("@","")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
Redis:sadd(NASA.."bots:folder",folder:gsub("@",""))
end
end
if not Redis:sismember(NASA.."bots:folder",userbot) then
send(msg.chat_id,msg.id,"*◍ عفواً، هذا البوت ليس ضمن البوتات المصنوعة !!*","md")
return false 
end
for screen in io.popen('ls /var/run/screen/S-root'):lines() do
Redis:sadd(NASA.."screen:on",screen)
end
local list = Redis:smembers(NASA..'screen:on')
for k,v in pairs(list) do
if v:match("(%d+)."..userbot) then
send(msg.chat_id,msg.id,"*◍ البوت يعمل بالفعل !!*", "md")
return false 
end
end
os.execute("cd @"..userbot.." ; screen -d -m -S "..userbot.." ./Run")
send(msg.chat_id,msg.id,"◍ تم تشغيل البوت @"..userbot.." بنجاح")
return false 
end
if text == "💾 | تشغيل بوت" then
Redis:set(NASA..msg.sender_id.user_id.."run:bot",true)
send(msg.chat_id,msg.id,"*◍ حسناً، قم بإرسال معرف البوت ليتم تشغيله*", "md")
return false 
end
---ايقاف البوتات
if text and Redis:get(NASA..msg.sender_id.user_id.."stop:bot") then
Redis:del(NASA..msg.sender_id.user_id.."stop:bot")
Redis:del(NASA.."screen:on")
Redis:del(NASA.."bots:folder")
userbot = text:gsub("@","")
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
Redis:sadd(NASA.."bots:folder",folder:gsub("@",""))
end
end
if not Redis:sismember(NASA.."bots:folder",userbot) then
send(msg.chat_id,msg.id,"*◍ عذراً، هذا البوت ليس ضمن البوتات المصنوعة .*","md")
return false 
end
for screen in io.popen('ls /var/run/screen/S-root'):lines() do
Redis:sadd(NASA.."screen:on",screen)
end
local list = Redis:smembers(NASA..'screen:on')
for k,v in pairs(list) do
if v:match("(%d+)."..userbot) then
os.execute('screen -X -S '..userbot..' quit')
send(msg.chat_id,msg.id,"◍ تم ايقاف @"..userbot.." بنجاح !!") --</> All Copyright ( BaNdA )
return false 
end
end
send(msg.chat_id,msg.id,"*◍ البوت متوقف بالفعل*", "md")
return false 
end
if text == "🗑️ | إيقاف بوت" then
Redis:set(NASA..msg.sender_id.user_id.."stop:bot",true)
send(msg.chat_id,msg.id,"*◍ قم بإرسال معرف البوت ليتم ايقافه*", "md")
return false 
end
----------
--الاشتراك الاجباري 
if Redis:get(NASA.."ch:addd"..msg.sender_id.user_id) == "on" then
Redis:set(NASA.."ch:addd"..msg.sender_id.user_id,"off")
local m = https.request("http://api.telegram.org/bot"..Token.."/getchat?chat_id="..text)
da = json:decode(m)
if da.result.invite_link then
local ch = da.result.id
send(msg.chat_id,msg.id,'*◍ تم حفظ القناة بنجاح*',"md",true)  
Redis:del(NASA.."chfalse")
Redis:set(NASA.."chfalse",ch)
Redis:del(NASA.."ch:sup")
Redis:set(NASA.."ch:sup",da.result.invite_link)
else
send(msg.chat_id,msg.id,'*◍ هناك خطأ ما وهو ان البوت ليس مشرف في القناه او ان المعرف الذي ارسلته خطأ*',"md",true)
end
end
if text == "☢️ | تفعيل الإجباري" then
Redis:set(NASA.."ch:addd"..msg.sender_id.user_id,"on")
send(msg.chat_id,msg.id,'*◍ قم بإرسال معرف قناة الاشتراك الاجباري ..*',"md",true)  
end
if text == "⚠️ | تعطيل الإجباري" then
Redis:del(NASA.."ch:sup")
Redis:del(NASA.."chfalse")
send(msg.chat_id,msg.id,'*◍ تم حذف قناة الاشتراك الاجباري ..*',"md",true)  
end
if text and Redis:get(NASA..msg.sender_id.user_id.."make:bot") == "devuser" then
local UserName = text:match("^@(.*)$")
if UserName then
local UserId_Info = LuaTele.searchPublicChat(UserName)
if not UserId_Info.id then
send(msg.chat_id,msg.id,"*◍ عذراً، هذا المعرف ليس لشخص ..*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
send(msg.chat_id,msg.id,"*◍ عذراً، هذا المعرف لقناة او لجروب وليس لشخص ..*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
send(msg.chat_id,msg.id,"*◍ عذراً، هذا المعرف لبوت وليس لشخص ..*","md",true)  
return false
end
local bottoken = Redis:get(NASA..msg.sender_id.user_id.."bottoken")
local botuser = Redis:get(NASA..msg.sender_id.user_id.."botuser")
local uu = LuaTele.getUser(UserId_Info.id)
local Informationlua = io.open("./MKNASA/Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..bottoken..[[",
UserBot = "]]..botuser..[[",
UserSudo = "]]..UserName..[[",
SudoId = ]]..UserId_Info.id..[[
}
]])
Informationlua:close()
os.execute('cp -a ./MKNASA/. ./@'..botuser..' && cd @'..botuser..' && chmod +x * && screen -d -m -S '..botuser..' ./Run')
Redis:sadd(NASA.."userbots",botuser)
Redis:del(NASA..msg.sender_id.user_id.."bottoken")
Redis:del(NASA..msg.sender_id.user_id.."botuser")
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
send(msg.chat_id,msg.id,"◍ تم تشغيل البوت بنجاح \n◍ معرف البوت [@"..botuser.."]\n◍ المطور ◍ ["..uu.first_name.."](tg://user?id="..UserId_Info.id..")","md",true)  
else
send(msg.chat_id,msg.id,"◍ اليوزر ليس لحساب شخصي تأكد منه ","md",true)  
end
end
if text and Redis:get(NASA..msg.sender_id.user_id.."make:bot") == "token" then
if text:match("(%d+):(.*)") then
local url = https.request("http://api.telegram.org/bot"..text.."/getme")
local json = JSON.decode(url)
if json.ok == true then
local botuser = json.result.username
if Redis:sismember(NASA.."userbots",botuser) then
send(msg.chat_id,msg.id, "\n*◍ هذا البوت بالفعل مصنوع !!*","md",true)  
return false 
end 
Redis:set(NASA..msg.sender_id.user_id.."botuser",botuser)
Redis:set(NASA..msg.sender_id.user_id.."bottoken",text)
Redis:set(NASA..msg.sender_id.user_id.."make:bot","devuser")
send(msg.chat_id,msg.id, "\n*◍ حسناً، قم بإرسل معرف المطور الاساسي الآن !!*", "md")
return false 
end
send(msg.chat_id,msg.id, "\n*◍ عذراً، التوكن الذي ارسلته غير صحيح قم بالتأكد منه !!*", "md")
return false
end
send(msg.chat_id,msg.id, "\n◍ من فضلك ارسل التوكن بشكل صحيح ")
end

if text == "✅ | صنع بوت" then
Redis:set(NASA..msg.sender_id.user_id.."make:bot","token")
send(msg.chat_id,msg.id, "\n◍ قم بإرسال توكن البوت المراد تنصيبة الآن ..","md",true)  
return false 
end 

----------end making


if text and Redis:get(NASA..msg.sender_id.user_id.."make:bot") == "del" then
if text == "الغاء" or text == '• الغاء الامر •' then   
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
send(msg.chat_id,msg.id, "\n◍ تم الغاء  الامر","md",true)  
return false 
end 
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
os.execute("sudo rm -fr "..text)
os.execute("screen -X -S "..text:gsub("@","").." quit")
Redis:srem(NASA.."userbots",text:gsub("@",""))
send(msg.chat_id,msg.id, "\n◍ تم حذف البوت من الصانع بنجاح ..","md",true)  
return false 
end 
if text == "❎ | حذف بوت" then
Redis:set(NASA..msg.sender_id.user_id.."make:bot","del")
send(msg.chat_id,msg.id, "\nحسناً، قم بإرسال معرف البوت الآن ..","md",true)  
return false 
end 
--By BaNdA

----end--3dd
if text == "🔓 | تفعيل التواصل" then
Redis:del(NASA.."TwaslBot")
send(msg.chat_id,msg.id,"تم تفعيل التواصل داخل الصانع ..")
return false 
end
if text == "🔒 | تعطيل التواصل" then
Redis:set(NASA.."TwaslBot",true)
send(msg.chat_id,msg.id,"تم تعطيل التواصل داخل الصانع ..")
return false 
end
if text == "✴️ | المشتركين" or text == "المشتركين" then
local list = Redis:smembers(NASA.."total")
send(msg.chat_id,msg.id,"اهلاً عزيزي المطور عدد مشتركين الصانع "..#list.." مشترك")
return false 
end
if text == 'رفع النسخه الاحتياطيه' and msg.reply_to_message_id ~= 0 or text == 'رفع نسخه احتياطيه' and msg.reply_to_message_id ~= 0 then
local Message_Reply = LuaTele.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Reply.content.document then
local File_Id = Message_Reply.content.document.document.remote.id
local Name_File = Message_Reply.content.document.file_name
if Name_File ~= UserBot..'.json' then
return send(msg_chat_id,msg_id,'◍ عذرا هاذا الملف غير مطابق مع البوت يرجى جلب النسخه الحقيقيه')
end -- end Namefile
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,''..Name_File) 
local Get_Info = io.open("./"..UserBot..".json","r"):read('*a')
local FilesJson = JSON.decode(Get_Info)
if tonumber(NASA) ~= tonumber(FilesJson.BotId) then
return send(msg_chat_id,msg_id,'◍ عذرا هاذا الملف غير مطابق مع البوت يرجى جلب النسخه الحقيقيه')
end -- end botid
send(msg_chat_id,msg_id,'◍جاري استرجاع المشتركين والجروبات ...')
Y = 0
for k,v in pairs(FilesJson.UsersBot) do
Y = Y + 1
Redis:sadd(NASA..'total',v)  
end
end
end
if text == "🧲 | جلب نسخه" then
local UsersBot = Redis:smembers(NASA.."total")
local Get_Json = '{"BotId": '..NASA..','  
if #UsersBot ~= 0 then 
Get_Json = Get_Json..'"UsersBot":['  
for k,v in pairs(UsersBot) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..']'
end
local File = io.open('./'..UserBot..'.json', "w")
File:write(Get_Json)
File:close()
return LuaTele.sendDocument(msg.chat_id,msg.id,'./'..UserBot..'.json', '*• تم جلب النسخه الاحتياطيه\n• تحتوي على 0 جروب \n• وتحتوي على {'..#UsersBot..'} مشترك *\n', 'md')
end
--By BaNdA

if Redis:get(NASA.."all:texting") then
if text == "الغاء" or text == '• الغاء الامر •' then   
Redis:del(NASA.."all:texting")
send(msg.chat_id,msg.id, "\n◍ تم الغاء الاذاعه","md",true)  
return false 
end 
Redis:set(NASA.."3z:gp",text)
Redis:del(NASA.."all:texting")
send(msg.chat_id,msg.id,"*جاري عمل اذاعة لجميع مجموعات البوتات المصنوعة ..*","md",true)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
for k,v in pairs(list) do
https.request("https://api.telegram.org/bot"..bottoken.."/sendmessage?chat_id="..v.."&text="..URL.escape("["..Redis:get(NASA.."3z:gp").."]").."&parse_mode=Markdown")
end
end
end
Redis:del(NASA.."3z:gp")
Redis:del(NASA.."all:texting")
send(msg.chat_id,msg.id,"◍ تم انتهاء الاذاعه في كل البوتات","md",true)
end
if Redis:get(NASA.."all:texting:pv") then
if text == "الغاء" or text == '• الغاء الامر •' then   
Redis:del(NASA.."all:texting:pv")
send(msg.chat_id,msg.id, "\n◍ تم الغاء الاذاعه","md",true)  
return false 
end 
Redis:set(NASA.."eza3a:pv",text)
Redis:del(NASA.."all:texting:pv")
send(msg.chat_id,msg.id,"*جاري عمل اذاعة لجميع المصنوعات ..*","md",true)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."Num:User:Pv") 
for k,v in pairs(list) do
https.request("https://api.telegram.org/bot"..bottoken.."/sendmessage?chat_id="..v.."&text="..URL.escape("["..Redis:get(NASA.."eza3a:pv").."]").."&parse_mode=Markdown")
end
end
end
Redis:del(NASA.."eza3a:pv")
Redis:del(NASA.."all:texting:pv")
send(msg.chat_id,msg.id,"◍ تم انتهاء الاذاعه في كل البوتات","md",true)
end
if Redis:get(NASA.."all:texting:guu") then
if text == "الغاء" or text == '• الغاء الامر •' then   
Redis:del(NASA.."all:texting:pv")
send(msg.chat_id,msg.id, "\n◍ تم الغاء الاذاعه","md",true)  
return false 
end 
Redis:set(NASA.."eza3a:guu",text)
Redis:del(NASA.."all:texting:pv")
send(msg.chat_id,msg.id,"*جاري عمل اذاعة لجميع المصنوعات ..*","md",true)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
botuser = x[2] 
devbot = x[3]
bottoken = x[4]
list = Redis:smembers(bot_id.."ChekBotAdd") 
for k,v in pairs(list) do
https.request("https://api.telegram.org/bot"..bottoken.."/sendmessage?chat_id="..v.."&text="..URL.escape("["..Redis:get(NASA.."eza3a:guu").."]").."&parse_mode=Markdown")
Redis:set(NASA.."PinMsegees:"..v,text)
end
end
end
Redis:del(NASA.."eza3a:guu")
Redis:del(NASA.."all:texting:guu")
send(msg.chat_id,msg.id,"◍ تم انتهاء الاذاعه في كل البوتات","md",true)
end
if text == "📢 | إذاعه عام للمجموعات" then
Redis:set(NASA.."all:texting",true)
send(msg.chat_id,msg.id,"*قم بإرسال لي النص الآن ليتم اذاعته في المجموعات ..*","md",true)
end
if text == "📮 | إذاعه عام للمشتركين" then
Redis:set(NASA.."all:texting:pv",true)
send(msg.chat_id,msg.id,"*قم بإرسال لي النص الآن ليتم اذاعته للمشتركين ..*","md",true)
end
if text == "📀 | اذاعه عام تثبيت" then
Redis:set(NASA.."all:texting:guu",true)
send(msg.chat_id,msg.id,"*قم بإرسال لي النص الآن ليتم اذاعته  بالتثبيت ..*","md",true)
end

--By BaNdA
if Redis:get(NASA..msg.sender_id.user_id.."brodcast") then 
if text == "الغاء" or text == '• الغاء الامر •' then   
Redis:del(NASA..msg.sender_id.user_id.."brodcast") 
send(msg.chat_id,msg.id, "\n◍ تم الغاء الاذاعه","md",true)  
return false 
end 
local list = Redis:smembers(NASA.."total") 
if msg.content.video_note then
for k,v in pairs(list) do 
LuaTele.sendVideoNote(v, 0, msg.content.video_note.video.remote.id)
end
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
for k,v in pairs(list) do 
LuaTele.sendPhoto(v, 0, idPhoto,'')
end
elseif msg.content.sticker then 
for k,v in pairs(list) do 
LuaTele.sendSticker(v, 0, msg.content.sticker.sticker.remote.id)
end
elseif msg.content.voice_note then 
for k,v in pairs(list) do 
LuaTele.sendVoiceNote(v, 0, msg.content.voice_note.voice.remote.id, '', 'md')
end
elseif msg.content.video then 
for k,v in pairs(list) do 
LuaTele.sendVideo(v, 0, msg.content.video.video.remote.id, '', "md")
end
elseif msg.content.animation then 
for k,v in pairs(list) do 
LuaTele.sendAnimation(v,0, msg.content.animation.animation.remote.id, '', 'md')
end
elseif msg.content.document then
for k,v in pairs(list) do 
LuaTele.sendDocument(v, 0, msg.content.document.document.remote.id, '', 'md')
end
elseif msg.content.audio then
for k,v in pairs(list) do 
LuaTele.sendAudio(v, 0, msg.content.audio.audio.remote.id, '', "md") 
end
elseif text then   
for k,v in pairs(list) do 
send(v,0,text,"md",true)  
end
end
send(msg.chat_id,msg.id,"◍ تمت الاذاعه الى *- "..#list.." * عضو في المجموعة ","md",true)      
Redis:del(NASA..msg.sender_id.user_id.."brodcast") 
return false
end

if text == "📡 | اذاعه" then
Redis:set(NASA..msg.sender_id.user_id.."brodcast",true)
send(msg.chat_id,msg.id,"ارسل لي النص الآن ليتم اذاعته ..")
return false 
end
---fwd
if Redis:get(NASA..msg.sender_id.user_id.."brodcast:fwd") then 
if text == "الغاء" or text == '• الغاء الامر •' then   
Redis:del(NASA..msg.sender_id.user_id.."brodcast:fwd")
send(msg.chat_id,msg.id,"\n*✭ تـم إلـغاء الإذاعـه بالـتوجيه !*","md",true)
return false 
end 
if msg.forward_info then 
local list = Redis:smembers(NASA.."total") 
send(msg.chat_id,msg.id,"*✪ تم التوجيه الي *"..#list.." *مشترك في البوت !!*","md",true)
for k,v in pairs(list) do  
LuaTele.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
end   
Redis:del(NASA..msg.sender_id.user_id.."brodcast:fwd")
end 
return false
end
if text == "🧭 | اذاعه بالتوجيه" then
Redis:set(NASA..msg.sender_id.user_id.."brodcast:fwd",true)
send(msg.chat_id,msg.id,"قم بإرسال التوجية الآن ليتم نشره ..")
return false 
end
--By BaNdA
------By BaNdA
if Redis:get(NASA.."all:BanAll") then
if not Redis:get(NASA.."all:BanAll") then
return false 
end
if text and text:match("^(%d+)$") then
local UserId = text:match("^(%d+)$") 
send(msg.chat_id,msg.id,"*جاري حظرو  ..*","md",true)
local BA0DA = LuaTele.getUser(UserId)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
Redis:sadd(bot_id.."BanAll:Groups",UserId) 
end 
end
send(msg.chat_id,msg.id," تم حظرو بنجاح ","md",true)  
return false 
end
end
if Redis:get(NASA.."KN:OPAll") then
if not Redis:get(NASA.."KN:OPAll") then
return false 
end
if text and text:match("^(%d+)$") then
local U = text:match("^(%d+)$") 
send(msg.chat_id,msg.id,"*جاري الغاء حظرو  ..*","md",true)
local BA0DA = LuaTele.getUser(U)
for folder in io.popen('ls'):lines() do
if folder:match('@[%a%d_]') then
m = Redis:get(folder)
x = {m:match("(.*)&(.*)$(.*)+(.*)")}
bot_id = x[1]
Redis:srem(bot_id.."BanAll:Groups",U) 
end 
end
send(msg.chat_id,msg.id,"تم الغاء الحظر ","md",true)  
return false 
end
end
if text == "🛡️ | الغاء العام" then
Redis:set(NASA.."KN:OPAll",true)
send(msg.chat_id,msg.id,"*قم بإرسال الشخص لي فك الحظر ..*","md",true)
end
if text == "🛡️ | حظر عام" then
Redis:set(NASA.."all:BanAll",true)
send(msg.chat_id,msg.id,"*قم بإرسال الشخص لحظرو ..*","md",true)
end

end -- sudo commands
if not Dev(msg) then
if text and ChannelJoin(msg.sender_id.user_id) == false then
local chinfo = Redis:get(NASA.."ch:sup")
local reply_markup = LuaTele.replyMarkup{type = 'inline',data = {{{text = 'اضغط للاشتراك', url = chinfo}, },}}
 LuaTele.sendText(msg.chat_id,msg.id,'*\n◍ عذراً، عليك الاشتراك في قناة البوت حتي تتمكن من استخدامه*',"md",false, false, false, false, reply_markup)
return false 
end
if not Redis:get(NASA.."twsl") then
if msg.sender_id.user_id ~= tonumber(NASA) then
if Redis:sismember(NASA..'BaN:In:Tuasl',msg.sender_id.user_id) then
return false 
end
if msg.id then
Redis:setex(NASA.."Twasl:UserId"..msg.date,172800,msg.sender_id.user_id)
LuaTele.forwardMessages(Sudo_Id, msg.chat_id, msg.id,0,0,true,false,false)
end   
end
end
if Redis:sismember(NASA..'BaN:In:Tuasl',msg.sender_id.user_id) then
return false 
end
if text and Redis:get(NASA.."free:bot") then
local reply_markup = LuaTele.replyMarkup{
type = 'inline',
data = {
{
{text = '👤 | مبرمج السورس', url = 't.me/Q_o_ll'}, 
},
{
{text = '🔘 | تواصل معنا', url = 't.me/U_00l'}, 
},
}
}
return send(msg.chat_id,msg.id,"⚠️ | عذار عزيزي المصنع وقف الان \n ☢️ | المصنع قيد التحديث\n⬇️ | تابع الازرار الي في الاسفل للتواصل معنا","md",false, false, false, false, reply_markup)
end
if text == "/start" then
if not Redis:sismember(NASA.."total",msg.sender_id.user_id) then
Redis:sadd(NASA.."total",msg.sender_id.user_id)
local list = Redis:smembers(NASA.."total")
LuaTele.sendText(Sudo_Id,0,'*\n• تم دخول شخص جديد الي البوت ..\n*',"md")
end
local news =[[
⏺️ | أهلا بك في صانع بوتات الحمايه 

✴️|  يمكنك الان صنع بوت واحد فقط 

💡|  عليك استخدام اوامر التحكم في الاسفل 
]]
reply_markup = LuaTele.replyMarkup{type = 'keyboard',resize = true,is_personal = true,
data = {
{
{text = '✅ | صنع بوت',type = 'text'},{text = '❎ | حذف بوت',type = 'text'},
},
{
{text = '🔹 | طريقه عمل بوت',type = 'text'},
},
{
{text = '• إلغاء •',type = 'text'},
},
}
}
send(msg.chat_id,msg.id,news,"md",true, false, false, true, reply_markup)
return false 
end


---making user
if text and Redis:get(NASA..msg.sender_id.user_id.."make:bot") then
if text == "• إلغاء •" then
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
send(msg.chat_id,msg.id,"*◍ تم الغاء امر صناعة البوت ..*","md")
return false 
end
if (text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") 
or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") 
or text and text:match("[Tt].[Mm][Ee]/") 
or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") 
or text and text:match(".[Pp][Ee]") 
or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") 
or text and text:match("[Hh][Tt][Tt][Pp]://") 
or text and text:match("[Ww][Ww][Ww].") 
or text and text:match(".[Cc][Oo][Mm]")) or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match(".[Tt][Kk]") or text and text:match(".[Mm][Ll]") or text and text:match(".[Oo][Rr][Gg]") then 
return send(msg.chat_id,msg.id,"⚡ |  لا يمكنك ارسال اي شيء غير التوكن \n يجب عليك ارسل التوكن فقط اي شئ ثاني ممنوع")
end 
local url = https.request("http://api.telegram.org/bot"..text.."/getme")
local json = JSON.decode(url)
if json.ok == true then
local botuser = json.result.username
if Redis:sismember(NASA.."userbots",botuser) then
send(msg.chat_id,msg.id, "\n◍ عذراً، هذا البوت بالفعل مصنوع ..","md",true)  
return false 
end 
local uu = LuaTele.getUser(msg.sender_id.user_id)
if uu.username then
username = uu.username
else
username = ""
end
if username == "" then
sudo_state = "["..uu.first_name.."](tg://user?id="..msg.sender_id.user_id..")" 
else
sudo_state = "[@"..username.."]" 
end
local allb = Redis:smembers(NASA..'3ddbots')
local Informationlua = io.open("./MKNASA/Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..text..[[",
UserBot = "]]..botuser..[[",
UserSudo = "]]..username..[[",
SudoId = ]]..msg.sender_id.user_id..[[
}
]])
Informationlua:close()
os.execute('cp -a ./MKNASA/. ./@'..botuser..' && cd @'..botuser..' && chmod +x * && screen -d -m -S '..botuser..' ./Run')
Redis:set(NASA..msg.sender_id.user_id.."my:bot",botuser)
Redis:sadd(NASA.."userbots",botuser)
Redis:del(NASA..msg.sender_id.user_id.."make:bot")
send(Sudo_Id,0,"عزيزي المطور تم تنصيب بوت جديد علي الصانع !!\n\n• توكن البوت `"..text.."`\n• يوزر البوت @["..botuser.."] \n• يوزر المطور "..sudo_state.."\n\n- اصبح عدد البوتات علي الصانع الآن : `"..#allb.."` بوت !!","md",true)
local reply_markup = LuaTele.replyMarkup{
type = 'inline',
data = {
{
{text = '👤 | مبرمج السورس', url = 't.me/B_o_d_a_90'}, 
},
{
{text = '☢️ | اضغط هنا لتنصيب', url = 't.me/Qrao_bot'}, 
},
{
{text = '🔘 | تواصل معنا', url = 't.me/E_s_l_a_m_Zelzal'}, 
},
}
}
send(-1001274438207,0,"*🛒 | تم تنصيب بوت علي سورس ناسا\n┄──━━━ ● ━━━──┄\n*⚜️ | يوزر البوت:- @["..botuser.."] *\n*🥇 | يوزر المطور :- "..sudo_state.."*\n*☢️ |  اصبح عدد البوتات علي الصانع الآن : `"..#allb.."` بوت*\n*","md",false, false, false, false, reply_markup)
send(msg.chat_id,msg.id,"• تـم حفـظ البيانـات وتشغـيل بوتـك بنجاح ‼️\n\n• يوزر البوت @["..botuser.."] \n• الـمـطـوࢪ "..sudo_state.."\n\n🔰 [.َ ‹ 𝙱𝙰𝙽𝙳𝙰 || بـانـدا .𓁷](t.me/B_o_d_a_90)\n🔰 [ٓٓ˹𝙎𝙤𝙐𝙧𝘾𝙚 𝙉𝙖𝙎𝙖 .⚡ ](t.me/SourseZezoMusic)","md",true)
return false 
end
send(msg.chat_id,msg.id,"⛔ |  التوكن غير صحيح تأكد منه ثم ارسلة مره اخري ..")
end

if text == "✅ | صنع بوت" then
if Redis:get(NASA..msg.sender_id.user_id.."my:bot") then
return send(msg.chat_id,msg.id,"عذراً، انت بالفعل قمت بصنع بوت لا يمكنك صنع اكثر من بوت في الصانع قم بحذف بوتك الثاني من ثم قم بصنع بوت جديد !")
end
Redis:set(NASA..msg.sender_id.user_id.."make:bot",true)
send(msg.chat_id,msg.id,"*◍ قم بإرسال توكن بوتك الآن ..*", 'md')
return false 
end
if text == "🔹 | طريقه عمل بوت" then
Redis:del(NASA..msg.sender_id.user_id.."make:bot",true)
local reply_markup = LuaTele.replyMarkup{
type = 'inline',
data = {
{
{text = '#️⃣ | اضغط هنا للحصول علي التوكن', url = 't.me/BotFather'}, 
},
{
{text = '🛂 | طريقه انشاء بوت', url = 't.me/'..UserBot..'?start=st'..msg_chat_id..'u'..msg.sender_id.user_id..''},  
},
{
{text = 'اخفاء الامر ', data =msg.sender_id.user_id..'/delAmr'},
},
}
}
send(msg.chat_id,msg.id,"*◍ الزر الاول للحصول علي التوكن \n ◍ الزر الثاني لمعرفه أنشأ البوت من الصفر ..*","md",false, false, false, false, reply_markup)
return false 
end
if text and text:match("/start st(.*)u(%d+)") then
local reply_markup = LuaTele.replyMarkup{type = 'inline',data = {
{{text = '- اخفاء الامر ', data =msg.sender_id.user_id..'/delAmr'},},}}
 send(msg.chat_id,msg.id,"https://telegra.ph/NASAbot-07-24","html",false, false, false, false, reply_markup)
end

----end making user
if text == "❎ | حذف بوت" then
if Redis:get(NASA..msg.sender_id.user_id.."my:bot") then
local botuser = Redis:get(NASA..msg.sender_id.user_id.."my:bot")
os.execute("sudo rm -fr @"..botuser)
os.execute("screen -X -S "..botuser.." quit")
Redis:srem(NASA.."userbots",botuser)
Redis:del(NASA..msg.sender_id.user_id.."my:bot")
send(msg.chat_id,msg.id, "\n*◍  تم حذف بوتك بنجاح*","md",true)  
else
send(msg.chat_id,msg.id, "\n*عذراً، انت لم تصنع بوت !*","md",true)  
end
end



end --non Sudo_Id
end--Run
function callback(data)
if data and data.luatele and data.luatele == "updateNewMessage" then
if tonumber(data.message.sender_user_id) == tonumber(NASA) then
return false
end
Run(data.message,data.message)
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local Message_Edit = LuaTele.getMessage(data.chat_id, data.message_id)
if Message_Edit.sender_id.user_id == NASA then
return false
end
Run(Message_Edit,Message_Edit)
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Text = LuaTele.base64_decode(data.payload.data)
IdUser = data.sender_user_id
ChatId = data.chat_id
Msg_id = data.message_id
---
if Text and Text:match('(%d+)/delAmr') then
local UserId = Text:match('(%d+)/delAmr')
if tonumber(IdUser) == tonumber(UserId) then
return LuaTele.deleteMessages(ChatId,{[1]= Msg_id})
end
end
end--data
end--callback 
luatele.run(callback)

