# <code>Customer Relationship Management Project</code>

[See Dependency Tree](https://github.com/piyush168713/thymeleafdemo-employees-crm-security-project/blob/master/pom.xml)


## <code>Key Features</code>

### CRUD
The CRUD stands for Create, Read/Retrieve, Update, and Delete. These are the four basic functions of the persistence storage.
The CRUD operation can be defined as user interface conventions that allow view, search, and modify information through computer-based forms and reports.

The controller is RESTFul and returns data in a JSON format.

controller/EmployeeController.java
```java
	 @GetMapping("/showFormForAdd")
		public String showFormForAdd(Model theModel) {

			// create model attribute to bind form data
			Employee theEmployee = new Employee();

			theModel.addAttribute("employee", theEmployee);

			return "/employees/employee-form";
		}
	
	
	@PostMapping("/save")
	public String saveEmployee(@ModelAttribute("employee") Employee theEmployee) {
		
		// save the employee
		employeeService.save(theEmployee);
		
		// use a redirect to prevent duplicate submissions
		return "redirect:/employees/list";
	}
```

``` java
	@GetMapping("/list")
	public String listEmployees(Model theModel) {
		
		// get employees from db
		List<Employee> theEmployees = employeeService.findAll();
		
		// add to the spring model
		theModel.addAttribute("employees", theEmployees);
		
		return "/employees/list-employees";
	}
```

```java
	@GetMapping("/showFormForUpdate")
	public String showFormForUpdate(@RequestParam("employeeId") int theId,
									Model theModel) {
		
		// get the employee from the service
		Employee theEmployee = employeeService.findById(theId);
		
		// set employee as a model attribute to pre-populate the form
		theModel.addAttribute("employee", theEmployee);
		
		// send over to our form
		return "/employees/employee-form";			
	}
```

```java
	@GetMapping("/delete")
	public String delete(@RequestParam("employeeId") int theId) {
		
		// delete the employee
		employeeService.deleteById(theId);
		
		// redirect to /employees/list
		return "redirect:/employees/list";
		
	}
```




### Sorting
Here we have the implementation of the sorting method.

service/EmployeeServiceImpl.java
```java
	@Override
	public List<Employee> findAll() {
		return employeeRepository.findAllByOrderByLastNameAsc();
	}
```


### Searching by name
```java
	@Override
	public List<Employee> searchBy(String theName) {
		
		List<Employee> results = null;
		
		if (theName != null && (theName.trim().length() > 0)) {
			results = employeeRepository.findByFirstNameContainsOrLastNameContainsAllIgnoreCase(theName, theName);
		}
		else {
			results = findAll();
		}
		return results;
	}
```

### User Authentication based on roles
In the application, we want to display content based on user role.

- Employee role: users in this role will only be allowed to list employees.
- Manager role: users in this role will be allowed to list, add and update employees.
- Admin role: users in this role will be allowed to list, add, update and delete employees. 

These restrictions are currently in place with the code: DemoSecurityConfig.java

```java
	@Override
	protected void configure(HttpSecurity http) throws Exception {

		http.authorizeRequests()
			.antMatchers("/employees/showForm*").hasAnyRole("MANAGER", "OWNER")
			.antMatchers("/employees/save*").hasAnyRole("MANAGER", "OWNER")
			.antMatchers("/employees/delete").hasAnyRole("ADMIN", "OWNER")
			.antMatchers("/employees/**").hasAnyRole("EMPLOYEE", "OWNER")
			.antMatchers("/resources/**").permitAll()
			.and()
			.formLogin()
				.loginPage("/showMyLoginPage")
				.loginProcessingUrl("/authenticateTheUser")
				.permitAll()
			.and()
			.logout().permitAll()
			.and()
			.exceptionHandling().accessDeniedPage("/access-denied");
	}
```
We also, want to hide/display the links on the view page. For example, if the user has only the "EMPLOYEE" role, then we should only display links available for "EMPLOYEE" role.
Links for "MANAGER" and "ADMIN" role should not be displayed for the "EMPLOYEE".

We can make use of Thymeleaf Security to handle this for us. 

1. Add support for Thymeleaf Security
To use the Thymeleaf Security, we need to add the following to the XML Namespace

File: list-employees.html

```HTML
<html lang="en" 
		xmlns:th="http://www.thymeleaf.org"
		xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity5">
```

Note the reference for xmlns:sec

2. "Update" button
Only display the "Update" button for users with role of MANAGER OR ADMIN
```HTML
	<div sec:authorize="hasAnyRole('ROLE_MANAGER', 'ROLE_OWNER')">
		<a th:href="@{/employees/showFormForAdd}"
			class="btn btn-primary btn-sm mr-5 mb-3">
			Add Employee
			</a>
		</div>
```

3. "Delete" buton
Only display the "Delete" button for users with role of ADMIN
```HTML
<!-- Add "delete" button/link -->					
	<a th:href="@{/employees/delete(employeeId=${tempEmployee.id})}"
		class="btn btn-danger btn-sm"
		onclick="if (!(confirm('Are you sure you want to delete this employee?'))) return false">
			Delete
	</a>
```


TEST THE APPLICATION
====================
0. Before running the application, make sure the database tables are set up (via SQL files).  Also, be sure to update application.properties for database connection (url, userid, pass)
```sql
	# JDBC properties
	#
	# app.datasource.jdbc-url=jdbc:mysql://localhost:3306/employee_directory?useSSL=false&serverTimezone=UTC
	app.datasource.jdbc-url=jdbc:mysql://localhost:3306/employee_directory_thymeleaf?useSSL=false&serverTimezone=UTC
	app.datasource.username=springstudent
	app.datasource.password=Piyush@168713

	# Spring Data JPA properties
	#
	spring.data.jpa.repository.packages=com.luv2code.springboot.thymeleafdemo.dao
	spring.data.jpa.entity.packages-to-scan=com.luv2code.springboot.thymeleafdemo.entity

	# SECURITY JDBC properties
	#
	security.datasource.jdbc-url=jdbc:mysql://localhost:3306/spring_security_demo_bcrypt_thymeleaf?useSSL=false&serverTimezone=UTC
	security.datasource.username=springstudent
	security.datasource.password=Piyush@168713
```

 
1. Run the Spring Boot application: ThymeleafdemoApplication.java
```java
	package com.luv2code.springboot.thymeleafdemo;

	import org.springframework.boot.SpringApplication;
	import org.springframework.boot.autoconfigure.SpringBootApplication;

	@SpringBootApplication
	public class ThymeleafdemoApplication {

		public static void main(String[] args) {
			SpringApplication.run(ThymeleafdemoApplication.class, args);
		}
	}
```

2. Open a web browser for the app: http://localhost:8080

3. Log in using one of the accounts

```c++
+---------+----------+-----------------------------+
| user id | password |            roles            |
+---------+----------+-----------------------------+
| john    | cse123   | ROLE_EMPLOYEE               |
| mary    | cse123   | ROLE_EMPLOYEE, ROLE_MANAGER |
| susan   | cse123   | ROLE_EMPLOYEE, ROLE_ADMIN   |
| chris   | cse123   | ROLE_EMPLOYEE, ROLE_OWNER   |
+---------+----------+-----------------------------+
```

4. Confirm that you can login and access data based on the roles.
