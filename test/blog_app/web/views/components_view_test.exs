defmodule BlogAppWeb.ComponentsViewTest do
  use BlogAppWeb.ConnCase, async: true
  import BlogAppWeb.ComponentsView
  import Phoenix.View

  test "relative_date/1 returns a relative date (ex: 1 day ago)" do
    date = Timex.shift(Timex.today, days: -3)
    assert relative_date(date) == "3 days ago"
  end

  test "short_date/1 returns a shorten date (ex: Nov 21, 2016)" do
    date = Timex.parse!("2016-02-29T00:00:00+00:00", "%FT%T%:z", :strftime)
    assert short_date(date) == "Feb 29, 2016"
  end

  test "summary/1 returns truncated summary of text" do
    txt = "<p>This giant of a whale says it is ready to begin planning a new swim later this afternoon. A powerful mammal that relies on fish and plankton instead of hamburgers.</p> <p>Archaeologists have found more than 40 tons of vinyl records, some more than a five years old, shedding light on early hipster trends.</p>"

    txt2 = "This giant of a whale says it is ready to begin planning a new swim later this afternoon. A powerful mammal that relies on fish and plankton instead of hamburgers. Archaeologists have found more than 40 tons of vinyl records, some more than a five years old, shedding light on early hipster trends...."

    assert summary(txt) == txt2
  end
end
