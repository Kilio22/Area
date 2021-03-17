FROM ubuntu:18.04

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

WORKDIR /home/developer

RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

RUN wget -q -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip -q sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29" >/dev/null
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

RUN wget -q https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.6-stable.tar.xz
RUN tar -xJf flutter_linux_1.22.6-stable.tar.xz
ENV PATH "$PATH:/home/developer/flutter/bin"

RUN flutter doctor

WORKDIR /app
COPY . .
RUN flutter pub get && flutter analyze . && flutter test --verbose && flutter build apk

ENTRYPOINT cp /app/build/app/outputs/apk/release/app-release.apk /apk/client.apk
