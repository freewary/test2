 <?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
* Portfolios Module Definition
*
* Declares the module, update code, etc.
*
* @author Steve West
* @copyright Alphamental
*
*
*/

class Portfolios_module extends Module {
	public $version = '1.0';
	public $name = 'portfolios';

	function __construct () {
		// set the active module
		$this->active_module = $this->name;
		
		parent::__construct();
	}
	
	/**
	* Pre-admin function
	*
	* Initiate navigation in control panel
	*/
	function admin_preload ()
	{
		$this->CI->admin_navigation->parent_link('alphamental','Alphamental');
		$this->CI->admin_navigation->child_link('alphamental',10,'Portfolios',site_url('admincp/portfolios'));
		$this->CI->admin_navigation->child_link('alphamental',20,'Trades',site_url('admincp/trades'));
	}
	
	/**
	* Module update
	*
	* @param int $db_version The current DB version
	*
	* @return int The current software version, to update the database
	*/
	function update ($db_version) {
		if ($db_version < '1.0') {
			// initial install
			$this->CI->db->query('CREATE TABLE `portfolios` (
 								 `portfolio_id` int(11) NOT NULL auto_increment,
								 `user_id` int(11) NOT NULL,
								 `date_created` datetime NOT NULL,
								 PRIMARY KEY  (`portfolio_id`)
								 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;'
								);
		
			/*
			$this->CI->db->query('CREATE TABLE `portfolio_entries` (
 								 `trade_id` int(11) NOT NULL auto_increment,
								 `portfolio_id` int(11) NOT NULL,
								 `initial_entry_date` datetime NOT NULL,
 								 `ticker_symbol` varchar(250) NOT NULL,
								 `quantity` int(11) NOT NULL,
								 `position` bit(1) NOT NULL,
							     PRIMARY KEY  (`trade_id`),
								 KEY `ticker_symbol` (`ticker_symbol`)
								 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;'
								);
								*/
		
			$this->CI->db->query('CREATE TABLE `portfolio_transactions` (
								 `transaction_id` int(11) NOT NULL auto_increment,
								 `portfolio_id` int(11) NOT NULL,
								 `transaction_date` datetime NOT NULL,
								 `ticker_symbol` varchar(250) NOT NULL,
								 `quantity` int(11) NOT NULL,
								 `cost_per` double NOT NULL,
								 PRIMARY KEY (`transaction_id`),
								 KEY `portfolio_id` (`portfolio_id`)
								 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;'
								);
		}
		
		// return current version
		
		return $this->version;
	}
}