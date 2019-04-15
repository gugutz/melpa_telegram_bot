defmodule PackagesBot.Melpa.Packages.Loader do
  alias PackagesBot.Melpa.Packages.Package
  alias PackagesBot.Repo
  import Ecto.Query

  def search_package(pattern) do
    pattern = "%#{pattern}%"

    query =
      from(
        p in Package,
        where: ilike(p.name, ^pattern) or ilike(p.description, ^pattern),
        order_by: [desc: p.total_downloads],
        limit: 5
      )

    Repo.all(query)
  end
end
