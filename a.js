var fields = [];
var Glob = require("glob").Glob;
var mg = new Glob(__dirname + "/*-bot/usage.json", {mark: true}, function(err, matches) {
    matches.forEach(function(match, i) {
        var titles = [];
        var usage = require(match);
        usage[0].fields.forEach(function(f, _) {
            titles.push(f.title);
        });
        fields[i] = {
            'title': usage[0].author_name,
            'value': titles.join('\n'),
            'short': false,
        };
    });
    //console.log(JSON.parse());
    console.log(JSON.stringify(fields));
});

