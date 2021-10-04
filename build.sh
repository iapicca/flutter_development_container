#!/bin/bash

container=$(buildah from docker.io/ubuntu:20.04)
buildah config --env DEBIAN_FRONTEND="noninteractive"
buildah config --env UID=1000
buildah config --env GID=1000
buildah config --env USER="developer"
buildah config --env JAVA_VERSION="8"
buildah config --env ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"
buildah config --env ANDROID_VERSION="29"
buildah config --env ANDROID_BUILD_TOOLS_VERSION="29.0.3"
buildah config --env ANDROID_ARCHITECTURE="x86_64"
buildah config --env ANDROID_SDK_ROOT="/home/$USER/android"


## TODO replace set up with fvm 
buildah config --env FLUTTER_VERSION="2.5.2"
buildah config --env FLUTTER_CHANNEL="stable"
buildah config --env FLUTTER_URL="https://storage.googleapis.com/flutter_infra/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
buildah config --env FLUTTER_HOME="/home/$USER/flutter"
## 

buildah config --env FLUTTER_WEB_PORT="8090"
buildah config --env FLUTTER_WEB_PORT="42000"
buildah config --env FLUTTER_EMULATOR_NAME="flutter_emulator"
buildah config --env PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH"

buildah run apt-get update \
  && apt-get install --yes --no-install-recommends openjdk-$JAVA_VERSION-jdk curl unzip sed git bash xz-utils libglvnd0 ssh xauth x11-xserver-utils libpulse0 libxcomposite1 libgl1-mesa-glx sudo \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

buildah run groupadd --gid $GID $USER \
  && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
  && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER

buildah config --user $USER  $container
buildah config --workingdir /home/user $container

buildah run mkdir -p $ANDROID_SDK_ROOT \
  && mkdir -p /home/$USER/.android \
  && touch /home/$USER/.android/repositories.cfg \
  && curl -o android_tools.zip $ANDROID_TOOLS_URL \
  && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
  && rm android_tools.zip \
  && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
  && yes "y" | sdkmanager "platform-tools" \
  && yes "y" | sdkmanager "emulator" \
  && yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE"


## TODO replace set up with fvm 
# flutter
buildah run curl -o flutter.tar.xz $FLUTTER_URL \
  && mkdir -p $FLUTTER_HOME \
  && tar xf flutter.tar.xz -C /home/$USER \
  && rm flutter.tar.xz \
  && flutter config --no-analytics \
  && flutter precache \
  && yes "y" | flutter doctor --android-licenses \
  && flutter doctor \
  && flutter emulators --create \
  && flutter update-packages

buildah copy $container flutter-web.sh /usr/local/bin/
buildah copy $container chown.sh /usr/local/bin/
buildah copy $container flutter-android-emulator.sh /usr/local/bin/flutter-android-emulator
buildahconmount=$(buildah mount $container)
buildah config --entrypoint '/usr/local/bin/entrypoint.sh'