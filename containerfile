FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

# ENV UID=1000
# ENV GID=1000
ENV USER="developer"
ENV FLUTTER_WEB_PORT="8090"
ENV FLUTTER_DEBUG_PORT="42000"
ENV ANDROID_CMD_TOOLS_VERSION="7583922"

ENV HOME             /home/${USER}
ENV ANDROID_SDK      ${HOME}/android
ENV DART_SDK         /usr/lib/dart
ENV PUB_CACHE        ${HOME}/.pub-cache
ENV FLUTTER_SDK      ${HOME}/fvm/default

ENV PATH "${PATH}:${ANDROID_SDK}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_SDK}/cmdline-tools/tools/bin"
ENV PATH "${PATH}:${ANDROID_SDK}/tools/bin"
ENV PATH "${PATH}:${ANDROID_SDK}/build-tools/30.0.2"
ENV PATH "${PATH}:${ANDROID_SDK}/platform-tools"
ENV PATH "${PATH}:${ANDROID_SDK}/emulator"
ENV PATH "${PATH}:${ANDROID_SDK}/bin"
ENV PATH "${PATH}:${DART_SDK}/bin"
ENV PATH "${PATH}:${PUB_CACHE}/bin"
ENV PATH "${PATH}:${FLUTTER_SDK}/bin"

RUN apt-get update -yqq && \
    apt-get install -y --no-install-recommends curl expect git sed openjdk-8-jdk wget bash unzip vim sudo apt-transport-https bash ssh libglvnd0 gnupg gnupg2 gnupg1 xauth x11-xserver-utils libpulse0 libxcomposite1 libgl1-mesa-glx && \
    sh -c "wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -" && \
    sh -c "wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list" && \
    apt-get update -y && \
    apt-get install dart && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log} 
 
# RUN groupadd --gid $GID $USER && \
#     useradd -s /bin/bash --uid $UID --gid $GID -m $USER && \
#     echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER && \
#     chmod 0440 /etc/sudoers.d/$USER

COPY tools /opt/tools
USER $USER
WORKDIR $HOME

RUN dart pub global activate fvm && \
    yes "y" | fvm global stable && \
    flutter config --android-sdk $ANDROID_SDK

RUN mkdir -p $ANDROID_SDK && \
    mkdir -p  $HOME/.android && \
    touch $HOME/.android/repositories.cfg && \
    curl -o android_tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMD_TOOLS_VERSION}_latest.zip && \
    unzip -qq -d $ANDROID_SDK android_tools.zip && \
    rm android_tools.zip && \
    mkdir -p $ANDROID_SDK/cmdline-tools/tools && \
    mv $ANDROID_SDK/cmdline-tools/bin $ANDROID_SDK/cmdline-tools/tools && \
    mv $ANDROID_SDK/cmdline-tools/lib $ANDROID_SDK/cmdline-tools/tools && \
    yes "y" | sdkmanager "build-tools;29.0.3" && \
    yes "y" | sdkmanager "platforms;android-29" && \
    yes "y" | sdkmanager "platform-tools" && \
    yes "y" | sdkmanager "emulator" && \
    yes "y" | sdkmanager "system-images;android-29;google_apis_playstore;x86_64"

COPY tools/entrypoint.sh /usr/local/bin/
COPY tools/chown.sh /usr/local/bin/
COPY tools/flutter-android-emulator.sh /usr/local/bin/flutter-android-emulator
ENTRYPOINT [ flutter doctor -v ]