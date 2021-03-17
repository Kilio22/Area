import 'package:area/area_services/discord_service.dart';
import 'package:area/area_services/github_service.dart';
import 'package:area/area_services/google_service.dart';
import 'package:area/area_services/microsoft_service.dart';
import 'package:area/area_services/timer_service.dart';
import 'package:area/area_services/twitter_service.dart';
import 'package:area/models/service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Services model", () {
    test('Discord model', () {
      Service discordService = DiscordService();

      expect(discordService.name, 'Discord');
      expect(discordService.uri, null);
      expect(discordService.callbackUrlScheme, null);
      expect(discordService.fullCallbackUrl, null);
      expect(discordService.serverRedirectUri, null);
      expect(discordService.iconPath, null);
      expect(discordService.hasActions, false);
      expect(discordService.hasReactions, true);
    });

    test('Github model', () {
      Service githubService = GithubService();

      expect(githubService.name, 'Github');
      expect(githubService.uri, '/connect/github');
      expect(githubService.callbackUrlScheme, 'area.app');
      expect(githubService.fullCallbackUrl, 'area.app://auth');
      expect(githubService.serverRedirectUri, '/connect/github/callback');
      expect(githubService.iconPath, 'assets/images/github.png');
      expect(githubService.hasActions, true);
      expect(githubService.hasReactions, true);
    });

    test('Google model', () {
      Service googleService = GoogleService();

      expect(googleService.name, 'Google');
      expect(googleService.uri, '/connect/google');
      expect(googleService.callbackUrlScheme, 'area.app');
      expect(googleService.fullCallbackUrl, 'area.app:/auth');
      expect(googleService.serverRedirectUri, '/connect/google/callback');
      expect(googleService.iconPath, 'assets/images/google.png');
      expect(googleService.hasActions, true);
      expect(googleService.hasReactions, false);
    });

    test('Microsoft model', () {
      Service microsoftService = MicrosoftService();

      expect(microsoftService.name, 'Microsoft');
      expect(microsoftService.uri, '/connect/microsoft');
      expect(microsoftService.callbackUrlScheme, 'msauth.area.app');
      expect(microsoftService.fullCallbackUrl, 'msauth.area.app://auth');
      expect(microsoftService.serverRedirectUri, '/connect/microsoft/callback');
      expect(microsoftService.iconPath, 'assets/images/microsoft.png');
      expect(microsoftService.hasActions, true);
      expect(microsoftService.hasReactions, true);
    });

    test('Timer model', () {
      Service timerModel = TimerService();

      expect(timerModel.name, 'Timer');
      expect(timerModel.uri, null);
      expect(timerModel.callbackUrlScheme, null);
      expect(timerModel.fullCallbackUrl, null);
      expect(timerModel.serverRedirectUri, null);
      expect(timerModel.iconPath, null);
      expect(timerModel.hasActions, true);
      expect(timerModel.hasReactions, false);
    });

    test('Twitter model', () {
      Service twitterService = TwitterService();

      expect(twitterService.name, 'Twitter');
      expect(twitterService.uri, '/connect/twitter');
      expect(twitterService.callbackUrlScheme, 'area.app');
      expect(twitterService.fullCallbackUrl, 'area.app://');
      expect(twitterService.serverRedirectUri, '/connect/twitter/callback');
      expect(twitterService.iconPath, 'assets/images/twitter.png');
      expect(twitterService.hasActions, false);
      expect(twitterService.hasReactions, true);
    });
  });
}
