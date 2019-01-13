let xplex = {
  getIngests () {
    $.getJSON('ingests.json').done((data) => {
      xplex.renderIngests(data)
    }).fail((xhr, status, error) => {
      if (xhr.status===404) {
        xplex.renderIngests(["Ingest settings not found. Let's create one!"])
        $("#ingests .list-group-item").last().addClass("no-ingest")
      } else {
        xplex.renderIngests([error])
        $("#ingests .list-group-item").last().addClass("no-ingest")
      }
    })
  },
  addIngest () {
    let newIngestURL  = $("#add-ingest input").val().trim()
    let rawIngestItem = $("#ingest-item-template").contents().clone()
    let rawIngestKick = $("#ingest-kick-template").contents().clone()

    if (!!newIngestURL) {
      $("#ingests .no-ingest").remove()

      $(rawIngestItem)
      .addClass("text-success")
      .append(rawIngestKick)
      .find(".ingest-url")
      .html(newIngestURL)

      $("#ingests .list-group").append(rawIngestItem)
  
      $("#add-ingest input").val("")
    }
  },
  renderIngests (data) {
    let rawIngestList = $("#ingest-list-template").contents().clone()
    let rawIngestItem = $("#ingest-item-template").contents().clone()
    let rawIngestKick = $("#ingest-kick-template").contents().clone()

    $("#ingests .no-ingest").remove()

    $(rawIngestItem).append(rawIngestKick)

    for (let d of data) {
      $(rawIngestItem)
      .addClass("text-secondary")
      .find(".ingest-url")
      .html(d)

      rawIngestList.append(rawIngestItem)
    }

    $("#ingests").html("")
    $("#ingests").append(rawIngestList)
  }
}

$(document).ready(() => {
  xplex.getIngests()

  $("#add-ingest").on("click", "button", xplex.addIngest)
  $("#add-ingest").on("keyup", "input", (e) => {
    if (e.key === "Enter") xplex.addIngest()
  })
  $("#ingests").on("click", "button.close", (e) => {
    $(e.target).parent().remove()
  })
  $("#ingests").on("click", "#commit", (e) => {
    let ingests = []
    $(".ingest-url").each((index, item) => {
      ingests.push(item.innerText)
    })

    $.post( "/ingests", {ingests}, () => {
      xplex.getIngests()
    })
  })
})
