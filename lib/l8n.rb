# stub for localizing
module L8n
  def l(text)
    text = text.to_s
    map = {
      'es' => {
        'Yes' => 'Si',
        'No' => 'No',
        'Date' => 'Fecha',
        'Declarer' => 'Declarador',
        'Accepter' => 'Acceptador',
        'Currency' => 'Moneda'
        }
      }
    k = map[current_user.pref_language]

    if k
      k[text] || text
    else  
      text
    end
  end
end