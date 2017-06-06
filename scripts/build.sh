if [ $TRAVIS_BRANCH == "dev" ]; then
    fastlane beta
elif [ $TRAVIS_BRANCH == "release" ]; then
    fastlane release
else
    fastlane test
fi