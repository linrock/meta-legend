if Rails.env.production?
  Rails.application.config.session_store :cookie_store,
    key: '_metalegend_session',
    expire_after: 30.days,
    httponly: true,
    secure: true
else
  Rails.application.config.session_store :cookie_store,
    key: '_metalegend_session',
    expire_after: 30.days,
    httponly: true
end
