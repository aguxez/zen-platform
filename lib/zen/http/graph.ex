defmodule Zen.HTTP.Graph do
  @moduledoc """
  HTTP utilities to post queries to The Graph
  """

  use Tesla

  @path "https://api.thegraph.com/subgraphs/id/QmdJRLUyyX3ETxWcrp3rrNJ8RZB24Cicej9kVQyLSFcrTH"

  plug Tesla.Middleware.BaseUrl, @path
  plug Tesla.Middleware.JSON, engine: Jason

  def post_query(query, variables \\ nil) do
    post("", %{query: query, variables: variables})
  end
end
