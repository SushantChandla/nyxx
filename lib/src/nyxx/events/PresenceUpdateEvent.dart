part of nyxx;

/// Sent when a member's presence updates.
class PresenceUpdateEvent {
  /// Member object, may be null.
  Member member;

  /// The new member.
  Presence presence;

  PresenceUpdateEvent._new(Map<String, dynamic> json) {
    if (client.ready) {
      //print("JSON: ${jsonEncode(json)}");
      //print("CURRENT GUILD LIST: ${client.guilds}");

      var guild = client.guilds[Snowflake(json['d']['guild_id'] as String)];

      if(guild != null)
        this.member = guild.members[Snowflake(json['d']['user']['id'] as String)];

      if(json['d']['game'] != null)
        this.presence = Presence._new(json['d']['game'] as Map<String, dynamic>);

      /*if(member == null && ['online', 'dnd', 'idle'].contains(json['d']['status'])) {
        if(this.member != null) {
          member.guild.members[member.id] = member;
          client.users[member.id] = member;
        }*/
      if(member != null && ['invisible', 'offline'].contains(json['d']['status'])) {
        member.guild.members.remove(member.id);
        client.users.remove(member.id);
      } else {
        if(member != null) {
          this.member.status = json['d']['status'] as String;
          this.member.presence = presence;
        }
      }

      client._events.onPresenceUpdate.add(this);
    }
  }
}
