<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
* Portfolio Model 
*
* Contains all the methods used to create, update, and delete portfolios.
*
* @author Steve West
* @copyright Alphamental
* 
*
*/

class Portfolio_model extends CI_Model
{
	
	
	function __construct()
	{
		parent::__construct();
		
		$this->alphadb = $this->load->database('alpha', TRUE);
		$this->db = $this->load->database('default', TRUE);		
	}
	
	function __destruct()
	{
		$this->alphadb->close();	
	}
	/**
	* Create New Portfolio
	*
	* @param string $user_id
	* 
 	*
 	* @return int $trading_cash
 	*/ 										
	function new_portfolio ($user_id) {		
		
		//$this->load->model('user_model');
						
		$this->alphadb->query('call a.APP_NEW_USR(' . $user_id .',@trading_cash)');
		
		$rs = $this->alphadb->query('select @trading_cash as trading_cash');
		
		$trading_cash = $rs->row_array();
		
		$rs->next_result();

		$rs->free_result();
		
		return $trading_cash;
	}
	/**
	* Get trade transactions
	*
	* @param string $user_id
	* 
 	*
 	* @return array $transactions
 	*/ 										
	function get_transactions ($user_id) {		
						
		$rs = $this->alphadb->query('call a.APP_USR_EXECUTIONS('.$user_id.')');
		
		if ($rs->num_rows() == 0) {
			return FALSE;
		}
		
		$transactions = array();		
		
		foreach ($rs->result_array() as $row) {					
			$transactions[] = array(
						'TransTmsp' => $row['TransTmsp'],
						'Usr_ak' => $row['Usr_ak'],
						'Security_k' => $row['Security_k'],
						'Qty_Opened' => $row['Qty_Opened'],
						'Price_Opened' => $row['Price_Opened'],
						'Qty_Closed' => $row['Qty_Closed'],
						'Qty_Open' => $row['Qty_Open'],
						'Price_Closed_Avg' => $row['Price_Closed_Avg'],
						'Closing_Price' => $row['Closing_Price'],
						'Notional_Value' => $row['Notional_Value'],
						'Realized_PL' => $row['Realized_PL'],
						'Unrealized_PL' => $row['Unrealized_PL'],
						'Required_Collateral' => $row['Required_Collateral'],
						'Symbol' => $row['Symbol']
					);
		}
		
		$rs->next_result();
		$rs->free_result();
		
		return $transactions;
	}
	/**
	*
	*
	*
	*
	*/
	function get_portfolio ($user_id) {
		
		$rs = $this->alphadb->query('call a.APP_USR_SECURITIES('.$user_id.')');
		
		if ($rs->num_rows() == 0) {
			return FALSE;
		}
		
		//echo "<pre>";
		//print_r($rs);
		//echo "</pre>";
		
		$securities = array();
		
		foreach ($rs->result_array() as $row) {					
			$securities[] = array(
						'Usr_ak' => $row['Usr_ak'],
						'Security_k' => $row['Security_k'],
						'Qty_Opened' => $row['Qty_Opened'],
						'Price_Opened_Avg' => $row['Price_Opened_Avg'],
						'Qty_Closed' => $row['Qty_Closed'],
						'Qty_Open' => $row['Qty_Open'],
						'Price_Closed_Avg' => $row['Price_Closed_Avg'],
						'Closing_Price' => $row['Closing_Price'],
						'Notional_Value' => $row['Notional_Value'],
						'Realized_PL' => $row['Realized_PL'],
						'Unrealized_PL' => $row['Unrealized_PL'],
						'Required_Collateral' => $row['Required_Collateral'],
						'Symbol' => $row['Symbol']
					);
		}
		
		$rs->next_result();
		$rs->free_result();
		
		return $securities;
	}
	//--------------------------------------------------------------------
	/**
	* Get User Custom Field
	*
	* @param int $custom_field_id
	*
	* @return boolean $custom_field or FALSE
	*/
	function get_custom_field ($id) {
		$return = $this->get_custom_fields(array('id' => $id));

		if (empty($return)) {
			return FALSE;
		}

		return $return[0];
	}

	/**
	* Get User Custom Fields
	*
	* Retrieves custom fields ordered by custom_field_order
	*
	* @param int $filters['id'] A custom field ID
	* @param boolean $filters['registration_form'] Set to TRUE to retrieve registration form fields
	* @param boolean $filters['not_in_admin'] Set to TRUE to not retrieve admin-only fields
	*
	* @return array $fields The custom fields
	*/
	function get_custom_fields ($filters = array()) {
		$cache_string = md5(implode(',',$filters));
		/*
		if (isset($this->cache_fields[$cache_string])) {
			return $this->cache_fields[$cache_string];
		}*/

		$this->load->model('custom_fields_model');

		if (isset($filters['id'])) {
			$this->db->where('user_field_id',$filters['id']);
		}

		if (isset($filters['registration_form']) and $filters['registration_form'] == TRUE) {
			$this->db->where('user_field_registration_form','1');
		}

		if (isset($filters['not_in_admin']) and $filters['not_in_admin'] == TRUE) {
			$this->db->where('user_field_admin_only','0');
		}

		$this->db->join('user_fields','custom_fields.custom_field_id = user_fields.custom_field_id','left');
		$this->db->order_by('custom_fields.custom_field_order','ASC');

		$this->db->select('user_fields.user_field_id');
		$this->db->select('user_fields.user_field_billing_equiv');
		$this->db->select('user_fields.user_field_admin_only');
		$this->db->select('user_fields.user_field_registration_form');
		$this->db->select('custom_fields.*');

		$this->db->where('custom_field_group','1');

		$result = $this->db->get('custom_fields');

		if ($result->num_rows() == 0) {
			return FALSE;
		}

		$billing_installed = module_installed('billing');

		$fields = array();
		foreach ($result->result_array() as $field) {
			$fields[] = array(
							'id' => $field['user_field_id'],
							'custom_field_id' => $field['custom_field_id'],
							'friendly_name' => $field['custom_field_friendly_name'],
							'name' => $field['custom_field_name'],
							'type' => $field['custom_field_type'],
							'options' => (!empty($field['custom_field_options'])) ? unserialize($field['custom_field_options']) : array(),
							'help' => $field['custom_field_help_text'],
							'order' => $field['custom_field_order'],
							'width' => $field['custom_field_width'],
							'default' => $field['custom_field_default'],
							'required' => ($field['custom_field_required'] == 1) ? TRUE : FALSE,
							'validators' => (!empty($field['custom_field_validators'])) ? unserialize($field['custom_field_validators']) : array(),
							'data' => (!empty($field['custom_field_data'])) ? unserialize($field['custom_field_data']) : array(),
							'billing_equiv' => ($billing_installed === TRUE) ? $field['user_field_billing_equiv'] : '',
							'admin_only' => ($field['user_field_admin_only'] == '1') ? TRUE : FALSE,
							'registration_form' => ($field['user_field_registration_form'] == '1') ? TRUE : FALSE
						);
		}

		//$this->cache_fields[$cache_string] = $fields;

		return $fields;
	}
	
	function get_hints ($hint) {
		$this->db->like('symbol', $hint);
		
		$result = $this->db->get('tickers_nasdaq');

		if ($result->num_rows() == 0) {
			return FALSE;
		}
		
		$fields = array();
		foreach ($result->result_array() as $field) {
			$fields[] = array(
							'id' => $field['id'],
							'symbol' => $field['symbol'],
							'name' => $field['name']
						);
		}

		return $fields;

	}

	function get_quote ($symbol) {
		$output = array();
		exec("/usr/local/lib/getquote.py $symbol", $output);
		
		$quotes = array();
		
		foreach ($output as $line) {
			if ($line != "") {
			$segment = explode("|", $line);
			
			$quotes[$segment[0]] = array(
							'symbol' => $segment[0],
							'last' => $segment[1],
							'last_ts' => $segment[2],
							'bid' => $segment[3],
							'ask' => $segment[4],
							'bid_size' => $segment[5],
							'ask_size' => $segment[6]			
							);
			}			
		}
		//echo '<pre>';
		//var_dump($quotes);
		//echo '</pre>';
		
		return $quotes;
	}
	
	//--------------------------------------------------------------------
}