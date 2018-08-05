echo "converting arrows to unicode..."
find src/ -type f -name "*.purs" -exec sed -i "" 's/<-/←/g' {} +
find src/ -type f -name "*.purs" -exec sed -i "" 's/->/→/g' {} +
find src/ -type f -name "*.purs" -exec sed -i "" 's/=>/⇒/g' {} +
find src/ -type f -name "*.purs" -exec sed -i "" 's/<=/⇐/g' {} +
find src/ -type f -name "*.purs" -exec sed -i "" 's/forall/∀/g' {} +
