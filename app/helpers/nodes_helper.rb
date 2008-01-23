module NodesHelper
  def render_body(node)
    body = h node.body
    body.gsub(/[\n\r]+/,'<br />')
  end
end
