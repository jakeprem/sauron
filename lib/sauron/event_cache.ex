# defmodule Sauron.EventCache do
#   require Cachex.Spec

#   @cache_name :event_cache
#   @cache_options [
#     expiration: Cachex.Spec.expiration(interval: :timer.minutes(10_080)),
#     limit: 5_000
#   ]

#   def child_spec(_args) do
#     %{
#       id: __MODULE__,
#       start: {Cachex, :start_link, [@cache_name, @cache_options]}
#     }
#   end

#   def put()
# end
