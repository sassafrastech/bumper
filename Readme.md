# Version Bump and Deploy Script

## Usage

```
bumper.rb <increment-type-or-explicit-version> [<deploy-env>]
```

## Examples

```
bumper.rb micro production   # Increment micro version and deploy to production
bumper.rb minor              # Increment minor version but don't deploy
bumper.rb 2.13p production   # Set version to v2.13p (don't include)
```

## Assumptions

* Deploy branch has same name as deploy env, except assumes `master` branch for `production`
* Development branch is called `develop`
* Changes requiring deploy are stored on `develop`
* Version is stored in VERSION file in project root
* Deployment via capistrano

## Results

* Sets VERSION to updated version (version in VERSION file does not have leading `v`)
* Creates and pushes new tag of form `vX.Y.Z`
* Deploys (if deploy-env param is given)
