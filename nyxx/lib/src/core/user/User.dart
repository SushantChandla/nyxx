part of nyxx;

/// Represents a single user of Discord, either a human or a bot, outside of any specific guild's context.
class User extends SnowflakeEntity with Mentionable, IMessageAuthor implements ISend {
  /// Reference to client
  final INyxx client;

  /// The user's username.
  @override
  late final String username;

  /// The user's discriminator.
  @override
  late final int discriminator;

  /// Formatted discriminator with leading zeros if needed
  String get formattedDiscriminator => discriminator.toString().padLeft(4, "0");

  /// The user's avatar hash.
  late final String? avatar;

  /// The string to mention the user.
  @override
  String get mention => "<@!${this.id}>";

  /// Returns String with username#discriminator
  @override
  String get tag => "${this.username}#${this.formattedDiscriminator}";

  /// Whether the user belongs to an OAuth2 application
  @override
  late final bool bot;

  /// Whether the user is an Official Discord System user (part of the urgent message system)
  late final bool system;

  /// The member's status. `offline`, `online`, `idle`, or `dnd`.
  ClientStatus? status;

  /// The member's presence.
  Activity? presence;

  /// Additional flags associated with user account. Describes if user has certain
  /// features like joined into one of houses or is discord employee.
  UserFlags? userFlags;

  /// Premium types denote the level of premium a user has.
  NitroType? nitroType;

  User._new(this.client, Map<String, dynamic> raw) : super(Snowflake(raw["id"])) {
    this.username = raw["username"] as String;
    this.discriminator = int.parse(raw["discriminator"] as String);
    this.avatar = raw["avatar"] as String?;
    this.bot = raw["bot"] as bool? ?? false;
    this.system = raw["system"] as bool? ?? false;

    if (raw["public_flags"] != null) {
      this.userFlags = UserFlags._new(raw["public_flags"] as int);
    }

    if (raw["premium_type"] != null) {
      this.nitroType = NitroType.from(raw["premium_type"] as int);
    }
  }

  /// Gets the [DMChannel] for the user.
  FutureOr<DMChannel> get dmChannel {
    final cacheChannel = client.channels.findOne((item) => item is DMChannel && item.participants.contains(this));

    if (cacheChannel != null) {
      return cacheChannel as DMChannel;
    }

    return client.httpEndpoints.createDMChannel(this.id);
  }

  /// The user's avatar, represented as URL.
  /// In case if user does not have avatar, default discord avatar will be returned with specified size and png format.
  @override
  String avatarURL({String format = "webp", int size = 128}) =>
      client._httpEndpoints.userAvatarURL(this.id, this.avatar, this.discriminator, format: format, size: size);

  /// Sends a message to user.
  @override
  Future<Message> sendMessage(
      {dynamic content,
        List<AttachmentBuilder>? files,
        EmbedBuilder? embed,
        bool? tts,
        AllowedMentions? allowedMentions,
        MessageBuilder? builder,
        ReplyBuilder? replyBuilder
      }) async {
    final channel = await this.dmChannel;
    return channel.sendMessage(
        content: content, files: files, embed: embed, tts: tts,
        allowedMentions: allowedMentions, builder: builder, replyBuilder: replyBuilder
    );
  }
}
