using System;
using System.Collections.Generic;

namespace FODS_API.Models
{
    public partial class Employee
    {
        public Employee()
        {
            Orders = new HashSet<Order>();
        }

        public int EmployeeId { get; set; }
        public string Department { get; set; } = null!;
        public string Nic { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string License { get; set; } = null!;
        public string Phone { get; set; } = null!;
        public string Username { get; set; } = null!;

        public virtual ICollection<Order> Orders { get; set; }
    }
}
