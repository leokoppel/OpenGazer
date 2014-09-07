#!/bin/bash

exit_script () {
  echo $1
  popd 2>&1 > /dev/null
  exit 1
}

pushd ~ 2>&1 > /dev/null

echo "Installing dependencies for OpenGazer...this may take a while..."

if [[ "$(uname)" == "Linux" ]] ; then
  echo "Installing libraries for OpenCV, GTK, Cairo, Boost, GSL, FANN and CMake"
  sudo apt-get update
  sudo apt-get install -y libopencv-* libgtkmm-2.4-dev libcairomm-1.0-dev libboost-dev libgsl0-dev libfann2 libfann-dev libv4dl-dev cmake libboost-system-dev libboost-filesystem-dev wget

  echo "Installing GSL from source"
  cd ~
  wget ftp://ftp.gnu.org/gnu/gsl/gsl-1.15.tar.gz
  tar zxvf gsl-1.15.tar.gz
  cd gsl-1.15
  ./configure
  make
  make install

  echo "Installing FFMPEG from source"
  ./ffmpeg.sh

elif [[ "$(uname)" == "Darwin" ]] ; then
  echo "OSX detected - this script hasn't yet been tested on OSX, but it should be fine. Press any key to continue or kill it now with Ctrl-C..."
  read

  if ! type brew 2>&1 > /dev/null ; then
    exit_script "You must first install Homebrew"
  fi

  if ! type xcodebuild 2>&1 > /dev/null ; then
    exit_script "You must first install Xcode"
  fi

  if [[ ! -d /Applications/Utilities/XQuartz ]] ; then
    exit_script "You must first install XQuartz"
  fi

  brew tap homebrew/science
  brew install gtkmm cairomm gsl cmake ffmpeg opencv fann boost

fi

popd 2>&1 /dev/null

echo "\n\nCompleted installing dependencies for OpenGazer!"
