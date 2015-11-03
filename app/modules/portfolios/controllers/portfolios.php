<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/*
* Portfolios Module
*
* Displays the My Portfolio
*
* @author Steve West
* @copyright Alphamental
* 
*/

class Portfolios extends Front_Controller {
	var $public_methods; // these methods can be accessed without being loggedin
	
	function __construct() {
		parent::__construct();
		
		$this->public_methods = array('validate','password_reset','login','post_login','forgot_password','post_forgot_password','register','post_registration');
		
		if (!in_array($this->router->fetch_method(), $this->public_methods) and $this->user_model->logged_in() == FALSE) {
			redirect('users/login?return=' . query_value_encode(current_url()));
		}
	}
	
	function index () {
		$this->load->model('portfolio_model');
		$this->load->model('user_model');
		
		$user_id = $this->user_model->get('id');
		
		$this->portfolio_model->get_quote('AAPL GOOG');
		
		//if ($this->portfolio_model->portfolio_exists($user_id) == FALSE) {
		$trading_cash =	$this->portfolio_model->new_portfolio($user_id);
		//}
		
		//$portfolio_id = $this->portfolio_model->get_portfolio_id($user_id);
		
		//$trades = $this->portfolio_model->get_trades(array('portfolio_id' => $portfolio_id));
				
		$notice = $this->session->flashdata('notice');

		$this->smarty->assign('notice', $notice);
		$this->smarty->assign('cash', $trading_cash);
		return $this->smarty->display('portfolio.thtml');		
	}
	
	function add () {
		$this->load->model('user_model');		
		$this->load->helper('form');
		
		$user_id = $this->user_model->get('id');
		
		$data = array(
					'form_title' => 'Create New Portfolio',
					'form_action' => site_url('admincp/portfolios/post/new')
				);
		
		$this->smarty->assign('notice', $notice);
		$this->smarty->assign('trades', $trades);
		return $this->smarty->display('portfolio.thtml');
		
	}
	
	function review () {
		print_r($_POST);
		
		$data = $_POST;
		
		$this->smarty->assign('data', $data);
		return $this->smarty->display('form.thtml');
	}
	
	function trade ($action = 'buy', $trade_id = FALSE) {
		$this->load->model('portfolio_model');
		$this->load->model('user_model');
		
		define('INCLUDE_CKEDITOR',TRUE);
		
		$this->load->helper('form');
		
		if ($action == 'buy') {
			$trade_id = $this->portfolio_model->new_trade(
										$this->portfolio_model->get_portfolio_id($this->user_model->get('id')),
										$this->input->post('ticker_symbol'),
										$this->input->post('quantity'),
										$this->input->post('cost_per')
									);
									
			//$this->notices->SetNotice('Trade was successful.');
			
			redirect('portfolios');
		}
		
		if ($action == 'sell') {
			
			$this->portfolio_model->delete_portfolio_entry($trade_id);
			
			redirect('portfolios');
		}
	}
	
	function gethint ($q) {
		$this->load->model('portfolio_model');
		//$q = $_REQUEST["q"];
		
		$hint = "";
		
		// lookup all hints from array if $q is different from ""
		if ($q !== "") {
			$q = strtoupper($q);
			$len=strlen($q);
			$i = 0;
			$hints = $this->portfolio_model->get_hints($q);
			
			if (!empty($hints)) {
				$hint .= '<ul>';
				foreach($hints as $name) {
					if ($i % 2 == 0) {
						$class = 'even';
					} else {
						$class = 'odd';
					}
					
					$i++;
					$hint .= '<li id="' . $name['id'] . '" class="'. $class .'"' . " onclick=\"hintValue('". $name['symbol'] ."')\">" . $name['symbol']. ' - ' .$name['name'] .'</li>';
				}
				$hint .= '</ul>';
			}
		}
		
		// Output "no suggestion" if no hint was found or output correct values
		echo $hint === "" ? "no suggestion" : $hint;
 
		
	}
	
	function get_hints () {
		
		$input = strtolower( $_GET['input'] );
		$len = strlen($input);
		
		
		
		
		$aResults = array();
		
		//if ($len)
		//{
			$this->load->model('portfolio_model');
			$tickers = $this->portfolio_model->get_hints($input);

			/*foreach ($tickers as $symbol)
			{
				// had to use utf_decode, here
				// not necessary if the results are coming from mysql
				//
				if (strtolower(substr(utf8_decode($symbol['symbol']),0,$len)) == $input)
					$aResults[] = array( 
										"id"=>$symbol['id'],
										"value"=>htmlspecialchars($tickers['symbol'],
										"name"=>$symbol['name']
										) ;
				
				//if (stripos(utf8_decode($aUsers[$i]), $input) !== false)
				//	$aResults[] = array( "id"=>($i+1) ,"value"=>htmlspecialchars($aUsers[$i]), "info"=>htmlspecialchars($aInfo[$i]) );
			}*/
		//}
		
		
		
		
		
		header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
		header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); // always modified
		header ("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
		header ("Pragma: no-cache"); // HTTP/1.0
		
		
		
		if (isset($_GET['json']))
		{
			header("Content-Type: application/json");
		
			echo "{\"results\": [";
			$arr = array();
			foreach ($tickers as $symbol)
			{
				$arr[] = "{\"id\": \"".$symbol['id']."\", \"value\": \"".$symbol['symbol']."\", \"info\": \"\"}";
			}
			echo implode(", ", $arr);
			echo "]}";
		}
		else
		{
			header("Content-Type: text/xml");

			echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?><results>";
			foreach ($tickers as $symbol)
			{
				//echo "<rs id=\""."\" info=\""."\">".$symbol['symbol']."</rs>";
				echo "<rs id=\"".$symbol['id']."\" info=\""."\">".$symbol['symbol']."</rs>";
			}
			echo "</results>";
		}
		
	}
	
	
}