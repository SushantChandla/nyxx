import 'package:nyxx/discord.dart' as discord;
import 'package:nyxx/vm.dart' as discord;

import 'dart:io';

void main() {
  discord.configureDiscordForVM();
  discord.Client bot =
      new discord.Client(Platform.environment['DISCORD_TOKEN']);

  var commands = new discord.Commands('!');
  commands.add(new PongCommand());
  commands.add(new EchoCommand());

  bot.onMessage.listen((discord.MessageEvent e) {
    commands.dispatch(e);
  });

  bot.onReady.listen((discord.ReadyEvent e) {
    print("Ready!");
  });
}

class PongCommand extends discord.Command {
  PongCommand() : super("ping", "Checks if bot is connected!", "!ping");

  @override
  run(discord.Message message) {
    message.channel.sendMessage(content: "Pong!");
  }
}

class EchoCommand extends discord.Command {
  EchoCommand() : super("echo", "Echoes bot message!", "!echo <message>");

  @override
  run(discord.Message message) {
    message.channel.sendMessage(content: message.content);
  }
}