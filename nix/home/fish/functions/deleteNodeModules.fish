function deleteNodeModules --description "Delete all node_modules folders in a folder and subfolders"
  find . -name "node_modules" -type d -exec rm -rf '{}' +
end
