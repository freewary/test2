<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/*
* Portfolios Control Panel
*
* Displays all control panel forms, datasets, and other displays
*
* @author Electric Function, Inc.
* @copyright Electric Function, Inc.
* @package Hero Framework
*
*/

class Admincp extends Admincp_Controller {
	function __construct()
	{
		parent::__construct();
		
		$this->admin_navigation->parent_active('alphamental');
	}
	
	function index () {	
		//$this->admin_navigation->module_link('New Portfolio',site_url('admincp/portfolios/add'));
	
		$this->load->library('dataset');
		
		$columns = array(
						array(
							'name' => 'Portfolio ID #',
							'type' => 'id',
							'width' => '20%',
							'filter' => 'portfolio_id'
							),
						array(
							'name' => 'User ID #',
							'type' => 'id',
							'width' => '20%',
							'filter' => 'user_id'							
							),
						array(
							'name' => 'Trades',
							'width' => '60%'
							)
					);
						
		$this->dataset->columns($columns);
		$this->dataset->datasource('portfolio_model','get_portfolios');
		$this->dataset->base_url(site_url('admincp/portfolios'));
		
		// initialize the dataset
		$this->dataset->initialize();

		// add actions
		$this->dataset->action('Delete','admincp/portfolios/delete');
		
		$this->load->view('portfolios');
	}
	
	
	function delete ($portfolios, $return_url) {
		$this->load->library('asciihex');
		$this->load->model('portfolio_model');
		
		$portfolios = unserialize(base64_decode($this->asciihex->HexToAscii($portfolios)));
		$return_url = base64_decode($this->asciihex->HexToAscii($return_url));
		
		foreach ($portfolios as $portfolio) {
			$this->portfolio_model->delete_portfolio($portfolio);
		}
		
		$this->notices->SetNotice('Portfolio(s) deleted successfully.');
		
		redirect($return_url);
		
		return TRUE;
	}
	
	function add () {
		
		$this->load->helper('form');
	
		$data = array(
					'form_title' => 'Create New Portfolio',
					'form_action' => site_url('admincp/portfolios/post/new')
				);
		
		$this->load->view('portfolio', $data);
	}

	function edit ($id) {
		
		$this->load->helper('form');
		
		$this->load->model('portfolio_model');
		$portfolio = $this->portfolio_model->get_portfolio($id);
		
		if (empty($portfolio)) {
			die(show_error('No portfolio exists with that ID.'));
		}	
		
		$data = array(
					'portfolio' => $portfolio,
					'form_title' => 'Edit Portfolio',
					'form_action' => site_url('admincp/portfolios/post/edit/' . $portfolio['portfolio_id'])
				);
		
		$this->load->view('portfolio', $data);
	}
	
	function post ($action = 'new', $id = FALSE) {
		$this->load->model('portfolio_model');
		
		if ($action == 'new') {
			$portfolio_id = $this->portfolio_model->new_portfolio(
										$this->input->post('user_id'),
										$this->input->post('nickname'),
										$this->input->post('url_path')
									);
										
			$this->notices->SetNotice('Portfolio added successfully.');
			
			/*
			redirect('admincp/portfolios/entries/' . $portfolio_id);
			*/
			redirect('admincp/portfolios');
		}
		elseif ($action == 'edit') {
			$this->portfolio_model->update_portfolio(
									$id,
									$this->input->post('user_id'),
									$this->input->post('nickname'),
									$this->input->post('url_path')									
								);
										
			$this->notices->SetNotice('Portfolio edited successfully.');
			
			redirect('admincp/portfolios');
		}
	}
	
	function trades ($portfolio_id = FALSE) {
		if (!empty($portfolio_id) and is_numeric($portfolio_id)) {
			$this->session->set_userdata('portfolio_id', $portfolio_id);
		}
		else {
			// this is likely a string of filters, not a form_id
			$portfolio_id = $this->session->userdata('portfolio_id');
		}
	
		$this->load->library('dataset');
		
		$columns = array(
						array(
							'name' => 'Trade ID #',
							'type' => 'id',
							'width' => '5%',
							'filter' => 'transaction_id'
							),
						array(
							'name' => 'Portfolio ID #',
							'type' => 'id',
							'width' => '5%',
							'filter' => 'portfolio_id'
							),
						array(
							'name' => 'Entry Date',
							'width' => '20%',
							'type' => 'date',
							'filter' => 'initial_entry_date',
							'field_start_date' => 'start_date',
							'field_end_date' => 'end_date'
							),
						array(
							'name' => 'Ticker Symbol',
							'width' => '30%',
							'type' => 'text',
							'filter' => 'ticker_symbol'
							),							
						array(
							'name' => 'Quantity',
							'width' => '30%',
							'filter' => 'quantity',
							'type' => 'text'
							)
					);
						
		$this->dataset->columns($columns);
		$this->dataset->datasource('portfolio_model','get_trades', array('portfolio_id' => $portfolio_id));
		$this->dataset->base_url(site_url('admincp/portfolios/trades'));
		
		// Set total rows here so we don't run out of memory 
		// trying to pull all of our results at once.
		$this->load->model('portfolio_model');
		$this->dataset->total_rows($this->portfolio_model->count_trades($portfolio_id, $this->dataset->get_filter_array()));
		
		// initialize the dataset
		$this->dataset->initialize();

		// add actions
		$this->dataset->action('Delete','admincp/portfolios/delete_trades');
		
		$this->load->view('trades');
	}
	
	function delete_responses ($responses, $return_url) {
		$this->load->library('asciihex');
		$this->load->model('form_model');
		
		$responses = unserialize(base64_decode($this->asciihex->HexToAscii($responses)));
		$return_url = base64_decode($this->asciihex->HexToAscii($return_url));
		
		foreach ($responses as $response) {
			$this->form_model->delete_response($this->session->userdata('responses_form_id'), $response);
		}
		
		$this->notices->SetNotice('Response(s) deleted successfully.');
		
		redirect($return_url);
		
		return TRUE;
	}
	
	function response ($form_id, $response_id) {
		$this->admin_navigation->module_link('Back to Responses','javascript:history.go(-1)');
	
		$this->load->model('form_model');
		
		$response = $this->form_model->get_response($form_id, $response_id);
		$form = $this->form_model->get_form($form_id);
		
		if (empty($response)) {
			die(show_error('Response doesn\'t exist.'));
		}
		
		$lines = array();
		$lines['Date'] = date('F j, Y, g:i a', strtotime($response['submission_date']));
		
		if (!empty($response['user_id'])) {
			$lines['Member Username'] = '<a href="' . site_url('admincp/users/profile/' . $response['user_id']) . '">' . $response['member_username'] . '</a>';
			$lines['Member Name'] = $response['member_first_name'] . ' ' . $response['member_last_name'];
			$lines['Member Email'] = $response['member_email'];
		}
		else {
			$lines['Member'] = 'None';
		}

		foreach ($form['custom_fields'] as $field) {
			if ($field['type'] == 'multiselect') {
				$value = implode(', ', unserialize($response[$field['name']]));
			}
			elseif ($field['type'] == 'file') {
				$value = $custom_fields[$field['name']] . ' (Download: ' . site_url('writeable/custom_uploads/' . $response[$field['name']]);
			}
			elseif ($field['type'] == 'date') {
				$value = date('F j, Y', strtotime($response[$field['name']]));
			}
			else {
				$value = $response[$field['name']];
				
				// automatically parse links
				$value = preg_replace('/(http:\/\/[^ )\r\n!]+)/i', '<a target="_blank" href="\\1">\\1</a>', $value);
				$value = preg_replace('/(https:\/\/[^ )\r\n!]+)/i', '<a target="_blank" href="\\1">\\1</a>', $value);
				$value = preg_replace('/([_\.0-9a-z-]+@([0-9a-z][0-9a-z-]+\.)+[a-z]{2,4})/i','<a href="mailto:\\1">\\1</a>', $value);
			}
			
			$lines[$field['friendly_name']] = $value;
		}
		
		$this->load->view('response', array('form' => $form, 'response' => $response, 'lines' => $lines));
	}
	
	function data () {
		$this->admin_navigation->parent_active('configuration');
		
		$this->admin_navigation->module_link('Add Custom Field',site_url('admincp/portfolios/data_add'));
		$this->admin_navigation->module_link('Preview &amp; Arrange Fields',site_url('admincp/custom_fields/order/1/' . urlencode(base64_encode(site_url('admincp/portfolios/data')))));
		
		$this->load->library('dataset');
		
		$columns = array(
						array(
							'name' => 'ID #',
							'type' => 'id',
							'width' => '5%'
							),
						array(
							'name' => 'Human Name',
							'width' => '19%'
							),
						array(
							'name' => 'System Name',
							'width' => '15%'
							),
						array(
							'name' => 'Type',
							'type' => 'text',
							'width' => '10%'
							),
						array(
							'name' => 'Billing Address Field?',
							'width' => '15%'
							),
						array(
							'name' => 'Admin Only?',
							'width' => '11%'
							),
						array(
							'name' => 'Registration Form?',
							'width' => '15%'
							),
						array(
							'name' => '',
							'width' => '15%'
							)
					);
						
		$this->dataset->columns($columns);
		$this->dataset->datasource('portfolio_model','get_custom_fields');
		$this->dataset->base_url(site_url('admincp/portfolios/data'));
		$this->dataset->rows_per_page(1000);
		
		// initialize the dataset
		$this->dataset->initialize();

		// add actions
		$this->dataset->action('Delete','admincp/portfolios/data_delete');
		
		// we may not have all of the fields in the `user_fields` table, because they are created in the
		// custom_fields controller and not here
		if (!empty($this->dataset->data)) {
			foreach ($this->dataset->data as $field) {
				if (!isset($field['id'])) {
					$this->portfolio_model->update_custom_field($field['custom_field_id'], '', FALSE, FALSE);
				}
			}
		}
		
		$this->load->view('data.php');
	}
}