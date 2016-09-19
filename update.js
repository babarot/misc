var child_process = require('child_process');

function updateSelf(bot, message){
  child_process.exec('git reset --hard origin/master', function(error, stdout, stderr){
    bot.reply(message, 'Botが更新されました！');
    bot.reply(message, 'Botを再起動します');
    setTimeout(function(){
      process.exit();
    }, 2000);
  });
}

controller.hears(['update'], 'direct_mention', function(bot, message) {
  bot.reply(message, 'Botのアップデートを開始します');

  child_process.exec('git fetch', function(error, stdout, stderr){
    child_process.exec('git log master..origin/master', function(error, stdout, stderr){
      if(stdout == ""){
        bot.reply(message, 'Botは最新です');
      }else{
        bot.startConversation(message, function(error, convo){
          bot.reply(message, '更新内容は以下のとおりです');
          bot.reply(message, '```\n' + stdout + '\n```');
          convo.ask('アップデートを行いますか？(y/n)', [
            {
              pattern: bot.utterances.yes,
              callback: function(response, convo){
                updateSelf(bot, message);
                convo.next();
              }
            },
            {
              pattern: bot.utterances.no,
              callback: function(response, convo){
                bot.reply(message, 'アップデートを中止します');
                convo.next();
              }
            },
            {
              pattern: 'じゃあそれで',
              callback: function(response, convo){
                updateSelf(bot, message);
                convo.next();
              }
            },
            {
              default: true,
                callback: function(response, convo){
                  convo.repeat();
                  convo.next();
                }
            }
          ]);
        });
      }
    });
  });
});
