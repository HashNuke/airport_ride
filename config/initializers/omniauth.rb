Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '114308221991692', 'd0760e8127dba7e2ae39c8416003df2b', {:scope => 'publish_stream,offline_access,email'}
end