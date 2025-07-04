VERSION=v$1

echo "This script is for tagging a new release of the workflow - not for making a release of other projects!"

if [ $(git tag -l "$VERSION") ]; then
    echo "Release tag $VERSION already exists."
    exit 1
else
    echo "Going for release $VERSION"
    WORKFLOW_PATH=".github/workflows/reusable-release.yml"

    sed -i '.bak' "s/@main/@$VERSION/g" $WORKFLOW_PATH && git checkout --detach && git add $WORKFLOW_PATH && git commit -m "Release $VERSION" && git tag $VERSION

    git clean -f
    git checkout main
    git show $VERSION    
fi
