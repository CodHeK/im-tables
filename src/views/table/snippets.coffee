scope 'intermine.snippets.table',
  NoResults: (query) -> _.template """
    <tr>
      <td colspan="<%= views.length %>">
        <div class="im-no-results alert alert-info">
          <div <% if (revision === 0) { %> style="display:none;" <% } %> >
            #{ intermine.snippets.query.UndoButton }
          </div>
          <strong>NO RESULTS</strong>
          This query returned 0 results.
          <div style="clear:both"></div>
        </div>
      </td>
    </tr>
    """, query
  # A function of the form ({count: i, first: i, last: i, roots: str}) -> str
  CountSummary: _.template """
    """
  Pagination: _.template """
      <div class="pagination pagination-right">
        <ul>
          <li class="<%= gotoStart %>" title="Go to start">
            <a class="im-pagination-button" data-goto=start>&#x21e4;</a>
          </li>
          <li class="<%= goFiveBack %>" title="Go back five pages" class="visible-desktop">
            <a class="im-pagination-button" data-goto=fast-rewind>&#x219e;</a>
          </li>
          <li class="<%= goOneBack %>" title="Go to previous page">
            <a class="im-pagination-button" data-goto=prev>&larr;</a>
          </li>
          <li class="im-current-page">
            <% if (useSelect) { %>
              <form class="im-page-form input-append form form-horizontal">
                <div class="control-group">
                  <select class="form-control">
                    <% for (i = 0; i < max; i++) { %>
                      <option
                        <%= selected(i) ? 'selected' : void 0 %>
                        value="<%= i * size %>">page <%= i + 1 %></option>
                    <% } %>
                  </select>
                <div>
              </form>
            <% } else { %>
              <a data-goto=here href="#">&hellip;</a>
              <form class="im-page-form input-append form form-horizontal"
                    style="display:none;">
                <div class="control-group">
                </div>
              </form>
            <% } %>
          </li>
          <li class="<%= goOneForward %>" title="Go to next page">
            <a class="im-pagination-button" data-goto=next>&rarr;</a>
          </li>
          <li class="<%= goFiveForward %>" title="Go forward five pages" class="visible-desktop">
            <a class="im-pagination-button" data-goto=fast-forward>&#x21a0;</a>
          </li>
          <li class="<% gotoEnd %>" title="Go to last page">
            <a class="im-pagination-button" data-goto=end>&#x21e5;</a>
          </li>
        </ul>
      </div>
    """

scope 'intermine.snippets.query', {
    UndoButton: """
          <button class="btn btn-primary pull-right">
            <i class="#{ intermine.icons.Undo }"></i> undo
          </button>
        """
}